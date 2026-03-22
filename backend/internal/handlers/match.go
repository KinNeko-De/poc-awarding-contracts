package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/kinneko-de/poc-awarding-contracts/backend/internal/matcher"
	"github.com/kinneko-de/poc-awarding-contracts/backend/internal/models"
	"github.com/kinneko-de/poc-awarding-contracts/backend/internal/parser"
)

// matchRequest is the JSON body expected by POST /api/match.
type matchRequest struct {
	ProfileText string `json:"profile_text"`
}

// matchResponse is returned by POST /api/match.
type matchResponse struct {
	Profile models.Profile       `json:"profile"`
	Matches []models.MatchResult `json:"matches"`
}

// MatchHandler returns an http.HandlerFunc that parses a freelancer profile
// and returns scored contract matches.
func MatchHandler(contracts []models.Contract) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req matchRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, "invalid request body", http.StatusBadRequest)
			return
		}

		if req.ProfileText == "" {
			http.Error(w, "profile_text must not be empty", http.StatusBadRequest)
			return
		}

		skills := parser.ExtractSkills(req.ProfileText)
		matches := matcher.Match(skills, contracts)

		resp := matchResponse{
			Profile: models.Profile{ExtractedSkills: skills},
			Matches: matches,
		}
		// Return an empty array rather than null when there are no matches.
		if resp.Matches == nil {
			resp.Matches = []models.MatchResult{}
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(resp)
	}
}
