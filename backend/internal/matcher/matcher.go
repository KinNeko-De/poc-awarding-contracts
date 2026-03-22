// Package matcher scores contracts against a set of extracted skills.
package matcher

import (
	"sort"
	"strings"

	"github.com/kinneko-de/poc-awarding-contracts/backend/internal/models"
)

// Match scores each contract against the profile skills and returns results
// sorted by score descending.  Contracts with a score of zero are excluded.
func Match(profileSkills []string, contracts []models.Contract) []models.MatchResult {
	results := make([]models.MatchResult, 0, len(contracts))

	for _, contract := range contracts {
		matching := intersect(profileSkills, contract.RequiredSkills)
		if len(matching) == 0 {
			continue
		}
		score := float64(len(matching)) / float64(len(contract.RequiredSkills)) * 100.0
		results = append(results, models.MatchResult{
			Contract:       contract,
			Score:          score,
			MatchingSkills: matching,
		})
	}

	sort.Slice(results, func(i, j int) bool {
		return results[i].Score > results[j].Score
	})

	return results
}

// intersect returns elements from a that also appear in b (case-insensitive).
func intersect(a, b []string) []string {
	set := make(map[string]struct{}, len(b))
	for _, v := range b {
		set[strings.ToLower(v)] = struct{}{}
	}

	out := make([]string, 0)
	for _, v := range a {
		if _, ok := set[strings.ToLower(v)]; ok {
			out = append(out, v)
		}
	}
	return out
}
