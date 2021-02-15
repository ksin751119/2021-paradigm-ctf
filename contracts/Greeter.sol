pragma solidity ^0.6.0;
// import 'hardhat/console.sol';

contract Greeter {

    string greeting;

    constructor(string memory _greeting) public {
        greeting = _greeting;
    }

    function greet() public view returns (string memory) {
        // console.log('mamami %s', msg.sender);
        return greeting;
    }

    function setGreeting(string memory _greeting) public {
        // console.log("try");
        greeting = _greeting;
    }

}
