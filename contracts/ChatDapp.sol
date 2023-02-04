// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 < 0.9.0;

contract ChatApp {
    
    struct user {
        string name;
        friend[] friendList;
    }

    struct friend{
        address pubkey;
        string name;
    }

    struct message{
        address sender;
        uint256 timestamp;
        string msg;
    }

    mapping (address => user) userList;
    mapping (bytes32 => message) allMessages;

    // check user exist
    function checkUserExist(address _pubkey) public view returns (bool) {
        return bytes(userList[_pubkey].name).length > 0;
    }

    // create acccount

    function createAccount(string calldata name) external {
        require(checkUserExist(msg.sender)== false, "User already exist");
        require(bytes(name).length > 0, "Username cannot be empty");
        userList[msg.sender].name = name;
    }

    // get username
    function getUsername(address pubkey) external view returns(string memory){
        require(checkUserExist(pubkey), "user not register");
        return userList[pubkey].name;
    }

    // Add friends
    function addFriend(address friend_key, string calldata name) external{
        require(checkUserExist(msg.sender),"create account");
        require(checkUserExist(friend_key), "user is not register");
        require(msg.sender != friend_key, "user cannot add themselves");
        require(checkAlreadyFriends(msg.sender,friend_key)==false, "user is aleady friend");
        _addfriend(msg.sender, friend_key, name);
        _addfriend(friend_key, msg.sender, userList[msg.sender].name);

    }

    function checkAlreadyFriends(address )

}