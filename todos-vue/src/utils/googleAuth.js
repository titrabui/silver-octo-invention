const gAuthOptions = {
  clientId: process.env.GAUTH_APP_CLIENT_ID,
  scope: process.env.GAUTH_APP_SCOPE,
  prompt: 'select_account'
}

export default gAuthOptions
