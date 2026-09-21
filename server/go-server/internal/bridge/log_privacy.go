package bridge

import (
	"io"
	"regexp"
	"strings"
)

// Redact at the writer boundary: wrapped network/TLS errors must not bypass it.
var privateEndpoints = []*regexp.Regexp{
	regexp.MustCompile(`(?i)\b(?:https?|wss?|tls|tcp|udp)://[^\s"'<>]+`),
	regexp.MustCompile(`\[[0-9a-fA-F:%]+\](?::[0-9]+)?`),
	regexp.MustCompile(`\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}(?::[0-9]+)?`),
	regexp.MustCompile(`(?i)\b(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z]{2,63}(?::[0-9]+)?\b`),
	regexp.MustCompile(`(?i)\blocalhost(?::[0-9]+)?\b`),
	regexp.MustCompile(`(?i)\b(?:[a-z_]*port|endpoint|address|addr)\s*[=:]\s*[^\s,;]+`),
	regexp.MustCompile(`(?i)\b(?:tcp|udp)\s+:[0-9]+`),
}

func RedactLog(text string) string {
	for _, pattern := range privateEndpoints {
		text = pattern.ReplaceAllStringFunc(text, func(value string) string {
			// Keep useful component filenames. Endpoint matches containing a
			// scheme or port never enter this exception.
			if !strings.ContainsAny(value, ":/=") {
				for _, ext := range []string{".exe", ".dll", ".dat", ".log", ".json", ".xml", ".crt", ".pem"} {
					if strings.HasSuffix(strings.ToLower(value), ext) {
						return value
					}
				}
			}
			return "[NET_ENDPOINT]"
		})
	}
	return text
}

type PrivateLogWriter struct{ io.Writer }

func (w PrivateLogWriter) Write(p []byte) (int, error) {
	s := RedactLog(string(p))
	n, err := io.WriteString(w.Writer, s)
	if err == nil && n != len(s) {
		err = io.ErrShortWrite
	}
	if err != nil {
		return 0, err
	}
	return len(p), nil
}
