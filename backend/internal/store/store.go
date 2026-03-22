// Package store loads and exposes the embedded contract data.
package store

import (
	_ "embed"
	"encoding/json"
	"log"

	"github.com/kinneko-de/poc-awarding-contracts/backend/internal/models"
)

//go:embed contracts.json
var contractsData []byte

// LoadContracts parses the embedded contracts.json and returns the contracts.
// It terminates the program if the data is malformed (should never happen in
// a correctly built binary).
func LoadContracts() []models.Contract {
	var contracts []models.Contract
	if err := json.Unmarshal(contractsData, &contracts); err != nil {
		log.Fatalf("failed to parse embedded contracts: %v", err)
	}
	return contracts
}
