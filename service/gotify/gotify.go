package gotify

import (
	"errors"
	"fmt"
	"net/http"
	"net/url"
)

// Notification is a gotify notification.
type Notification struct {
	AppURL  string
	Message string
	Title   string
	Token   string
	Client  *http.Client
}

// Send sends a gotify notification.
func (n *Notification) Send() error {
	switch {
	case n.AppURL == "" || n.Token == "":
		return errors.New("missing authentication token or App URL")
	case n.Message == "":
		return errors.New("missing message text")
	}

	baseurl := fmt.Sprintf("%s/message?token=%s", n.AppURL, n.Token)

	resp, err := n.Client.PostForm(baseurl, url.Values{"message": {n.Message}, "title": {n.Title}})
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	return nil
}
