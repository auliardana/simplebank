package utils

import (
	"math/rand"
	"strings"
	"time"
)

const alphabet = "qwertyuiopasdfghjklzxcvbnm"

func init() {
	rand.Seed(time.Now().UnixNano())
}

// generates a random integer between min and max
func RandomInt(min, max int64) int64 {
	return min + rand.Int63n(max-min+1)

}

//generate random string of length n
func RandomString(n int) string{

	var sb strings.Builder
	k := len(alphabet)

	for i:= 0 ; i<n; i++{
		c := alphabet[rand.Intn(k)]
		sb.WriteByte(c)
	}

	return sb.String()

}

// generate a random owner name
func RandomOwner() string{
	return RandomString(6)
}

func RandomMoney() int64 {
	return RandomInt(0,1000)
}

func RandomCurrency() string{
	currencies := []string{"EUR", "USD", "CAD"}
	n := len(currencies)
	return currencies[rand.Intn(n)]
}

func RandomEmail() string{
	return RandomString(6) + "@gmail.com"
}