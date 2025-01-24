package api

import (
	"os"
	"testing"

	db "github.com/auliardana/simple-bank/db/sqlc"
	"github.com/auliardana/simple-bank/utils"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/require"
)

func newTestServer(t *testing.T, store db.Store) *Server {
	config := utils.Config{
		TokenSymmetricKey:          utils.RandomString(32),
		AccessTokenDuration: 15,
	}
	server, err := NewServer(config, store)
	require.NoError(t, err)

	return server

}

func TestMain(m *testing.M) {

	gin.SetMode(gin.TestMode)
	os.Exit(m.Run())

}
