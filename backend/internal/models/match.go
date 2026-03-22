package models

// MatchResult pairs a contract with a computed similarity score.
type MatchResult struct {
	Contract       Contract `json:"contract"`
	Score          float64  `json:"score"`
	MatchingSkills []string `json:"matching_skills"`
}
