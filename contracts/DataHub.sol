// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract DataHub {
    address private owner;
    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    mapping(address => mapping(string => bytes32[])) datahub;

    event DataRegistered(
        address indexed owner,
        string name,
        uint256 index,
        bytes32 commitment
    );

    constructor() {
        owner = msg.sender;
        emit OwnerSet(address(0), owner);
    }

    function register(
        string calldata name,
        uint256 index,
        bytes32 commitment
    ) public {
        if (index == datahub[msg.sender][name].length) {
            datahub[msg.sender][name].push(commitment);
        } else if (index == datahub[msg.sender][name].length - 1) {
            datahub[msg.sender][name][index] = commitment;
        } else {
            revert("You cannot update other data blocks except the last block");
        }

        emit DataRegistered(
            msg.sender,
            name,
            index,
            commitment
        );
    }

    modifier dataExists(
        address addr,
        string calldata name,
        uint256 index
    ) {
        require(index < datahub[addr][name].length);
        _;
    }

    function getDataCommitment(
        address addr,
        string calldata name,
        uint256 index
    ) public view dataExists(addr, name, index) returns (bytes32 commitment) {
        commitment = datahub[addr][name][index];
    }

}