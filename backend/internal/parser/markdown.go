// Package parser extracts known IT skills from free-form Markdown text.
package parser

import (
	"regexp"
	"strings"
)

// knownKeywords is the seed list of IT skills the parser recognises.
// The list is intentionally kept in its canonical casing; matching is
// case-insensitive at runtime.
var knownKeywords = []string{
	"Go", "Golang",
	"Java", "Python", "C#", "JavaScript", "TypeScript", "Dart",
	"Flutter", "React", "Angular", "Vue.js",
	"Node.js", "Spring Boot",
	"gRPC", "REST API", "GraphQL",
	"Docker", "Kubernetes", "Terraform",
	"AWS", "Azure", "GCP",
	"PostgreSQL", "Oracle", "MySQL", "SQL", "MongoDB", "Redis",
	"Linux", "OWASP",
	"Scrum", "Agile", "Microservices",
	"Penetration Testing", "IT-Projektmanagement",
	"CI/CD", "DevOps",
	"Android", "iOS",
}

// ExtractSkills scans raw markdown text and returns every keyword from
// knownKeywords that appears in it (case-insensitive, preserving canonical
// casing, deduplicated).
func ExtractSkills(markdownText string) []string {
	found := make([]string, 0, len(knownKeywords))
	for _, kw := range knownKeywords {
		pattern := `(?i)\b` + regexp.QuoteMeta(kw) + `\b`
		matched, _ := regexp.MatchString(pattern, markdownText)
		if matched {
			// Avoid duplicates caused by aliases (e.g. "Go" / "Golang").
			if !containsCaseInsensitive(found, kw) {
				found = append(found, kw)
			}
		}
	}
	return found
}

func containsCaseInsensitive(slice []string, s string) bool {
	lower := strings.ToLower(s)
	for _, v := range slice {
		if strings.ToLower(v) == lower {
			return true
		}
	}
	return false
}
