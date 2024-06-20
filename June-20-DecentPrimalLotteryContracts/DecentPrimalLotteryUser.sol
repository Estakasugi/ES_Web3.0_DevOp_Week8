// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/*
    @author: ES_TAKASUGI

    @state variables:

        1. MaxAmountOfInEtherCurrentPool:  the max amount of ether a user spent in the current pool, use this state variables to keep track of when to start the pool counting down
                                            this state varaibale is only accessible to its inherit

    @major functions:

        1. createUserInfo(string memory _userName) external:
            short: an address outside the contract can create an user account
            input: address(included as msg.sender), string(username) 
            output: N/A
        
        2. checkMyUserInfo() external view validUser() returns(string memory, uint32, bool, uint256):
            short: an address outside who is a valid user is allowed to check their user account info
            input: address(included as msg.sender)
            output: username, total cost in ether, if the user is winner, how much did they win
        
        
        3. validateUserName(string memory str) internal pure:
            short: legal check user name, it has to be either number, alphabetic, or underscore. Also requires 3 <= usernameLength <= 20
            input: username
            output: N/A
*/

import "./Ownable.sol";
import "./SafeMath.sol";

contract DecentPrimalLotteryUser is Ownable {

    /*Utilizing additional features*/
    using SafeMath for uint256;

    /******** Section 1-Variables, database, and mapping *******/

    // the max amount of ether a user spent in the current pool, use this state variables to keep track of when to start the pool counting down
    uint256 internal MaxAmountOfInEtherCurrentPool = 0.0005 ether;
    
    // structure for user of the lottery
    struct UserInfo { 
        string userName;
        uint256 totalCostInEtherCurrentPool;  
        bool isWinnerOfCurrentPool;
        uint256 winningAmountOfCurrentPool;
    }

    // this data base is only interactable within the contracts and its heritage
    UserInfo[] internal usersDataLedger;

    /* some mappings for searchings
     * they are internal, users outside the contract are not allowed to access
     */
    mapping (string => address) internal userNameToAddress;  // This is the seraching map that given a userName, returns the its address.
    mapping (address => UserInfo) internal addressToUserInfo;  // This is the seraching map that given an address, returns the its user information
    mapping (string => UserInfo) internal userNameToUserInfo; // This is the seraching map that given a userName, returns the its user information


    /******* Section 2-Modifiers *******/

    // This function modifier ensures that the address has a valid user account in the lottery system
    modifier validUser() {
        // solidity does not allow string comp, this is the standard way to handle string comparison
        require( keccak256(abi.encodePacked(addressToUserInfo[msg.sender].userName)) != keccak256(abi.encodePacked("")), "User does not exist" ); 
        _;
    }


    /******* Section 3-Functions ******/

    // This function will create a UserInfo Struct and store it into usersDataLedger,
    // this function is interacable with functions/users/contracts outside of the contract
    function createUserInfo(string memory _userName) external  { // changed to external from public
        //user name legal/secure/lenght checking
        validateUserName(_userName);
        // check if a username has been previously taken
        require(userNameToAddress[_userName] == 0x0000000000000000000000000000000000000000, "This user name has been taken.");
        // make sure one address can only reginster one account 
        require( keccak256(abi.encodePacked(addressToUserInfo[msg.sender].userName)) == keccak256(abi.encodePacked("")), "One address can only create one account." );

        // push the created userinfo to the dataledger
        UserInfo memory newUser = UserInfo({
            userName: _userName,
            totalCostInEtherCurrentPool: 0,
            isWinnerOfCurrentPool: false,
            winningAmountOfCurrentPool: 0
        }); 

        usersDataLedger.push(newUser);
        
        // update seraching maps
        userNameToAddress[_userName] = msg.sender;
        addressToUserInfo[msg.sender] = newUser;
        userNameToUserInfo[_userName] = newUser;
    }

    // Let the address know its user information
    function checkMyUserInfo() external view validUser() returns(string memory, uint256, bool, uint256) { // changed from public to external
        
        return (addressToUserInfo[msg.sender].userName, 
                addressToUserInfo[msg.sender].totalCostInEtherCurrentPool, 
                addressToUserInfo[msg.sender].isWinnerOfCurrentPool, 
                addressToUserInfo[msg.sender].winningAmountOfCurrentPool);
    }

    // This is the function that legal check user name, it has to be either number, alphabetic, or underscore. Also requires 3 <= usernameLength <= 20 
    // Solidity doesn’t natively support regular expressions. Instead, use assembly code to perform this validation. 
    function validateUserName(string memory str) internal pure {
        //In Solidity, strings are dynamically-sized and you can’t directly get the length of a string without first converting it to bytes. 
        require(bytes(str).length > 3 && bytes(str).length < 20, "Invalid string length. Length must be greater than 3 and less than 20.");
        bytes memory b = bytes(str);
        for(uint i; i<b.length; i++){
            bytes1 char = b[i];
            require((char >= bytes1(uint8(65)) && char <= bytes1(uint8(90))) || // A-Z
                    (char >= bytes1(uint8(97)) && char <= bytes1(uint8(122))) || // a-z
                    (char >= bytes1(uint8(48)) && char <= bytes1(uint8(57))) || // 0-9
                    char == bytes1(uint8(95)), // _
                    "Invalid characters in user name. String can only contain alphabetic characters, numbers, and underscores.");
        }
    }

    // This function finds the maxCost of users
    // for now, this function is mannually checking by the owner of the contract, later on this funciton can be automated(every week, every 24 hrs,...)
    function findMaxCostInEtherAmongUsers() public view onlyOwner() returns(uint256) { // this function is acutally very cheap for it does not change state of a block chain
        
        uint256 maxUserAmountInEtherCurrentPool = 0;

        for (uint256 i = 0; i < usersDataLedger.length; i = i.add(1)) { //i.add(i) is the safer version of i++ utilizing the safe math lib
            if (usersDataLedger[i].totalCostInEtherCurrentPool > maxUserAmountInEtherCurrentPool){
                maxUserAmountInEtherCurrentPool = usersDataLedger[i].totalCostInEtherCurrentPool;
            }   
        }
    
        return maxUserAmountInEtherCurrentPool;
    }


}
