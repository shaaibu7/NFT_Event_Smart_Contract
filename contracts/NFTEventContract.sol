// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// User can create new event
// Event should have id to identify it
// User can register for an event with valid NFT

import "./interfaces/IERC721.sol";

contract EventNftManager {
    address owner;

    constructor () {
        owner = msg.sender;
    }

    struct Event {
        address ownerAddress;
        uint256 createTime;
        address nftAddress;
        uint256 eventId;
    }

    mapping (uint => Event) eventData;
    mapping (address => mapping(uint => bool)) confirmUserReg;
    uint256 eventCount = 1;

    function createEvent(address _nftAddress) external {
        Event memory newEvent = Event({
            ownerAddress: msg.sender,
            createTime: block.timestamp,
            nftAddress: _nftAddress,
            eventId: eventCount
        });
        eventData[eventCount] = newEvent;

        eventCount = eventCount + 1;
    }

    function getEvent(uint _id) external view  returns (Event memory){
        return eventData[_id];
    }

    function registerEvent(uint256 _eventId) external {
        require(eventData[_eventId].eventId == _eventId, "Event not found");

        bool confirm = confirmUserReg[msg.sender][_eventId];
        require(!confirm, "User has already registered for his event");

        address eventNftAddress = eventData[_eventId].nftAddress;

        // Check if user holds the event NFT
        uint256 userNft = IERC721(eventNftAddress).balanceOf(msg.sender);

        // User must have at least 1 NFT for the event to register
        if(userNft > 0) {
            confirmUserReg[msg.sender][_eventId] = true;
        }
    }

} 