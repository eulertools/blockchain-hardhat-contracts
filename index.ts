const { Amplify, Auth } = require('aws-amplify');

const path = require('path');

const fs = require('fs');

const { promisify } = require('util');

require('dotenv').config();

let networkType = process.env.NETWORK_TYPE

if(!networkType) networkType = 'bsctest'

const networkConfigPath = path.join(__dirname, '..','blockchain-hardhat-contracts', 'config', 'network', `${networkType}.json`);

const networkConfig = JSON.parse(fs.readFileSync(networkConfigPath));
//Nopuede abrir el archivo desde aca, or por aca, es el writeFIle
const authIdToken = async () => {
  const parameters = {
    aws_cognito_region: process.env.AWS_REGION,
    aws_user_pools_id: process.env.AWS_COGNITO_POOL_ID,
    aws_user_pools_web_client_id: process.env.AWS_COGNITO_CLIENT_ID
  }

  Amplify.configure(parameters);

  const user = await Auth.signIn(process.env.AWS_COGNITO_USER, process.env.AWS_COGNITO_PASSWORD);

  return user.signInUserSession.idToken.jwtToken;
}

const writeFileAsync = promisify(fs.writeFile);
const jsonPath = networkConfigPath;

export {writeFileAsync, networkConfig, jsonPath, authIdToken}
