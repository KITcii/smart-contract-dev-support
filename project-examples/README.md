## Quickstart Test Setup
We have created a few tests for our patterns. There are currently only examples available for Ethereum


### Ethereum Setup
Install Truffle and Ganache

    npm install --save-dev @openzeppelin/test-helpers

Launch Ganache:

    npx ganache-cli -l 1000000000
    
    
Run the test in a second Terminal window via (make sure you are in the /ethereum subdirectory) :

    truffle test     
