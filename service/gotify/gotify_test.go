package gotify

import (
	"net/http"
	"testing"
)

func TestNotification_Send(t *testing.T) {
	type fields struct {
		AppURL  string
		Message string
		Title   string
		Token   string
		Client  *http.Client
	}
	tests := []struct {
		name    string
		fields  fields
		wantErr bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			n := &Notification{
				AppURL:  tt.fields.AppURL,
				Message: tt.fields.Message,
				Title:   tt.fields.Title,
				Token:   tt.fields.Token,
				Client:  tt.fields.Client,
			}
			if err := n.Send(); (err != nil) != tt.wantErr {
				t.Errorf("Notification.Send() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}
