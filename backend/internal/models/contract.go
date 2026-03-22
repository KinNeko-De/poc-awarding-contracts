package models

// Contract represents a public German government IT contract.
type Contract struct {
	ID             string   `json:"id"`
	Title          string   `json:"title"`
	Description    string   `json:"description"`
	Authority      string   `json:"authority"`
	Location       string   `json:"location"`
	RemotePossible bool     `json:"remote_possible"`
	RequiredSkills []string `json:"required_skills"`
	Deadline       string   `json:"deadline"`
	EstimatedValue string   `json:"estimated_value"`
	Duration       string   `json:"duration"`
}
