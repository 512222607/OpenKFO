"""Prepare immutable OSS update objects. No credentials, upload or deployment."""
import argparse
import hashlib
import json
import re
import shutil
from pathlib import Path
from urllib.parse import quote, urlsplit


def sha(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def allowed(path, target):
    parts = path.split('/')
    if not path or any(x in ('', '.', '..') or x.endswith(('.', ' ')) for x in parts) or any(x in path for x in ('\\', ':')):
        return False
    if target == 'launcher':
        return path in ('启动器.exe', 'LauncherSupport.exe', 'native_assets.yaml') or ('/' not in path and path.endswith('.dll')) or path.startswith(('data/', 'launcher-files/'))
    return path.startswith(('Data/', 'effect/', 'GPK/', 'HostWidgets/', 'SDO/', 'spdata/', 'UI/', 'Weapon/')) or ('/' not in path and path.lower().endswith('.dll'))


def prepare(source, output, base, version, target, notes, previous=None, config_hash=None):
    old = {}
    if previous:
        data = json.loads(previous.read_text(encoding='utf-8-sig'))
        if data['target'] != target:
            raise ValueError('Previous manifest target mismatch')
        old = {row['path']: row for row in data['files']}
    # Client patches retain old resource entries so users can skip releases safely.
    entries = dict(old) if target == 'client' else {}
    for file in sorted(source.rglob('*')):
        if file.is_symlink():
            raise ValueError(f'Symlink not permitted: {file}')
        if not file.is_file() or file.suffix.lower() == '.pdb':
            continue
        path = file.relative_to(source).as_posix()
        if not allowed(path, target):
            raise ValueError(f'Not an update payload: {path}')
        size = file.stat().st_size
        if not 0 < size <= 256 * 1024 * 1024:
            raise ValueError(f'File size outside launcher limit: {path}')
        digest = sha(file)
        previous_row = old.get(path)
        if previous_row and previous_row['sha256'] == digest and previous_row['size'] == size:
            entries[path] = previous_row
            continue
        key = f'releases/{version}/{target}/{path}'
        dest = output / key
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(file, dest)
        entries[path] = {'path': path, 'url': base + quote(key, safe='/'), 'sha256': digest, 'size': size}
    names = [name.casefold() for name in entries]
    if len(names) != len(set(names)) or any(not allowed(name, target) for name in entries):
        raise ValueError('Duplicate or invalid manifest paths')
    if sum(row['size'] for row in entries.values()) > 512 * 1024 * 1024:
        raise ValueError('Manifest exceeds 512 MiB supported by current installer')
    if target == 'launcher' and not {'启动器.exe', 'LauncherSupport.exe', 'flutter_windows.dll', 'data/app.so'} <= entries.keys():
        raise ValueError('Complete Flutter launcher payload required')
    if len(entries) > (1024 if target == 'launcher' else 16384):
        raise ValueError('Too many files')
    manifest = {'version': version, 'target': target, 'notes': notes, 'files': list(entries.values())}
    if target == 'client':
        if not config_hash or not re.fullmatch('[0-9a-f]{64}', config_hash):
            raise ValueError('--config-hash required for client resources')
        if 'Data/config.spf2' in entries and entries['Data/config.spf2']['sha256'] != config_hash:
            raise ValueError('Data/config.spf2 hash mismatch')
        manifest['config_hash'] = config_hash
    key = f'manifest/{version}/{target}.json'
    dest = output / key
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding='utf-8')
    return base + key


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--launcher', type=Path, required=True)
    parser.add_argument('--client', type=Path)
    parser.add_argument('--config-hash')
    parser.add_argument('--previous-launcher', type=Path)
    parser.add_argument('--previous-client', type=Path)
    parser.add_argument('--version', required=True)
    parser.add_argument('--base-url', default='https://openkfo.oss-cn-hangzhou.aliyuncs.com/')
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--notes', default='启动器与客户端文件更新')
    args = parser.parse_args()
    endpoint = urlsplit(args.base_url)
    if endpoint.scheme != 'https' or not endpoint.netloc or endpoint.username or endpoint.query or endpoint.fragment:
        parser.error('Use an HTTPS base URL without credentials, query or fragment')
    if not re.fullmatch('[A-Za-z0-9][A-Za-z0-9._-]{0,79}', args.version):
        parser.error('Invalid release version')
    if not args.launcher.is_dir() or (args.client and not args.client.is_dir()):
        parser.error('Payload directory does not exist')
    if args.output.exists():
        parser.error('Output already exists; use a new directory/version')
    args.output.mkdir(parents=True)
    base = args.base_url.rstrip('/') + '/'
    version = {'version': args.version, 'manifest': prepare(args.launcher, args.output, base, args.version, 'launcher', args.notes, args.previous_launcher)}
    if args.client:
        version['client_manifest'] = prepare(args.client, args.output, base, args.version, 'client', args.notes, args.previous_client, args.config_hash)
    updater = args.output / 'updater' / args.version / 'updater.exe'
    updater.parent.mkdir(parents=True)
    shutil.copy2(args.launcher / 'LauncherSupport.exe', updater)
    # Publish this pointer only after every referenced object is uploaded.
    path = args.output / 'version/version.json'
    path.parent.mkdir()
    path.write_text(json.dumps(version, ensure_ascii=False, indent=2), encoding='utf-8')
    print(path)


if __name__ == '__main__':
    main()
