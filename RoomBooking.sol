// SPDX - License-Identifier: MIT

pragma solidity ^0.8.0;

contract HotelRoom{
    
    enum Status{
        Vacant,
        Occupied
    }

    Status public currentStatus;
    event Occupy(address _occupant,uint _value);
    address payable owner;

    constructor(){
        owner = payable(msg.sender);
        currentStatus = Status.Vacant;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "only owner can do checkout");
        _;
    }

    modifier onlyWhileVacant{
        require(currentStatus == Status.Vacant, "Currently occupied");
        _;
    }

    modifier onlyWhileOccupied{
        require(currentStatus == Status.Occupied, "Room not occupied");
        _;
    }

    modifier cost(uint _amount){
        require(msg.value >= _amount, "Not enough ether provided.");
        _;
    }

    function checkout() public onlyOwner onlyWhileOccupied{
        currentStatus = Status.Vacant;
    }
    function book() public payable onlyWhileVacant cost(2 ether){
        
        currentStatus = Status.Occupied;

        (bool sent, bytes memory data) = owner.call{value : msg.value}(""); 
        require(sent);

        emit Occupy(msg.sender,msg.value);
    }
}
