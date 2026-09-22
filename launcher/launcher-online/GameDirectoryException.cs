namespace KungFuLauncher;

// Expected installation guidance, shown without developer diagnostics.
internal sealed class GameDirectoryException : IOException
{
    internal GameDirectoryException() : base("请放到游戏目录下\n\n请将启动器放到完整游戏目录，与 Data 文件夹同级，然后重新打开。") { }
}
