## Quickstart Test Setup
We provide a tests for the developed software design patterns. There are currently only examples available for Ethereum


### Ethereum Setup
Install Truffle and Ganache

    npm install --save-dev @openzeppelin/test-helpers

Launch Ganache:

    npx ganache-cli -l 1000000000 --accounts 600
    
    
Run the test in a second Terminal window via (make sure you are in the /ethereum subdirectory) :

    truffle test     
