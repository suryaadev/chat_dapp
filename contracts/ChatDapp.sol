// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract ChatDapp {
    struct user {
        string name;
        friend[] friendList;
    }

    struct friend {
        address friend_address;
        string name;
    }

    struct message {
        address sender;
        uint256 timestamp;
        string content;
    }

    mapping(address => user) userList;
    mapping(bytes32 => message[]) allMessages;

    // function to check user is already exist or not this we will going to use later internal function
    function checkUserExist(address _address) public view returns (bool) {
        return bytes(userList[_address].name).length > 0;
    }

    // create account
    function createAccount(string calldata _name) external {
        require(checkUserExist(msg.sender) == false, "User already exist");
        // check name is empty or not
        require(bytes(_name).length > 0, "username cannot be empty");
        userList[msg.sender].name = _name;
    }

    // get username
    function getUsername(
        address _userAddress
    ) external view returns (string memory) {
        require(checkUserExist(_userAddress), "User does not exist");
        return userList[_userAddress].name;
    }

    //Addfriend function to add friend
    function addfriend(address _friendAddress, string calldata _name) external {
        // check msg.sender exist as user or not
        require(checkUserExist(msg.sender), "user does not exist");
        // check friend account is exist or not
        require(
            checkUserExist(_friendAddress),
            "friend account does not exist"
        );
        // check user is not adding himself
        require(msg.sender != _friendAddress, "you can't add yourself");
        // internal function t check alrady friend or not
        require(
            checkAlreadyFriend(msg.sender, _friendAddress) == false,
            "you guys are already friend"
        );
        // internal add friend function to actually adding friend
        _addfriend(msg.sender, _friendAddress, _name);
        _addfriend(_friendAddress, msg.sender, userList[msg.sender].name);
    }

    function checkAlreadyFriend(
        address _userAddress,
        address _friendAddress
    ) internal view returns (bool) {
        // here we see which list is bigger and comparing that whole list with the single address
        if (
            userList[_userAddress].friendList.length >
            userList[_friendAddress].friendList.length
        ) {
            address tmp = _userAddress;
            _userAddress = _friendAddress;
            _friendAddress = tmp;
        }
        for (uint256 i = 0; i < userList[_userAddress].friendList.length; i++) {
            if (
                userList[_userAddress].friendList[i].friend_address ==
                _friendAddress
            ) {
                return true;
            }
        }
        return false;
    }

    // internal add friend function
    function _addfriend(
        address _userAddress,
        address _friendAddress,
        string memory _name
    ) internal {
        friend memory newFriend = friend(_friendAddress, _name);
        userList[_userAddress].friendList.push(newFriend);
    }

    // print all friends associated with address
    function getMyFriends() external view returns (friend[] memory) {
        return userList[msg.sender].friendList;
    }

    // message section begins from here
    // get chatcode function is combination of user + friend address

    function _getChatCode(
        address _userAddress,
        address _friendAddress
    ) internal pure returns (bytes32) {
        if (_userAddress < _friendAddress) {
            return keccak256(abi.encodePacked(_userAddress, _friendAddress));
        } else {
            return keccak256(abi.encodePacked(_friendAddress, _userAddress));
        }
    }

    // function to send message
    function sendMessage(address _friendAddress, string memory _msg) external {
        // check send and reciever are exist or not
        require(checkUserExist(msg.sender), "user does not exist");
        require(
            checkUserExist(_friendAddress),
            "friend account does not exist"
        );
        // check if friend or not
        require(
            checkAlreadyFriend(msg.sender, _friendAddress),
            "send request first"
        );

        bytes32 chatCode = _getChatCode(msg.sender, _friendAddress);
        message memory newMessage = message(msg.sender, block.timestamp, _msg);
        allMessages[chatCode].push(newMessage);
    }

    // read messages

    function readMessages(
        address _friendAddress
    ) external view returns (message[] memory) {
        bytes32 chatCode = _getChatCode(msg.sender, _friendAddress);
        return allMessages[chatCode];
    }
}
