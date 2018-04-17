pragma solidity ^0.4.16;

/// @title Cab Service
contract CabService {
    uint tripCounter = 0;
    uint256 constant UINT256_MAX = ~uint256(0);

    enum TripState {request,driver_assigned,completed,abandoned}

    struct Driver {
        address driverId;
        bool isRegistered;
    }

    struct Trip {
        uint tripId;
        string source;
        string destination;
        TripState state;
        address customerId;
        address driver;
        uint amount;
    }

    struct Auction {
        uint tripId;
        uint state;
        mapping(address => uint) bids;
        uint minBid;
        address minBidder; // driver with the minimum bid
        address customerId;
        uint numBids;
    }

    mapping(uint => Trip) private trips;
    mapping(address => Driver) private drivers;
    mapping(uint => Auction) public auctions;


    event AuctionStarted(uint tripId);
    event AuctionEnded(uint tripId);

    function registerDriver() public{
        if (drivers[msg.sender].isRegistered == true) {
            revert();
        }
        drivers[msg.sender] = Driver({driverId : msg.sender, isRegistered : true});
    }

    function requestTrip(string source, string dest) public returns (uint rtripId){
        uint tripId;

        tripId = ++tripCounter;

        trips[tripId] = Trip({
            tripId:tripId,
            source:source,
            destination:dest,
            state:TripState.request,
            customerId:msg.sender,
            amount : 0,
            driver: 0x0
        });

        startAuction(tripId);

        return tripId;
    }

    function startAuction(uint tripId) private{
        auctions[tripId] = Auction({
            tripId : tripId,
            state : 1,
            customerId : msg.sender,
            minBidder : 0x0,
            numBids : 0,
            minBid : UINT256_MAX
        });
        emit AuctionStarted(tripId);
        return;
    }

    function endAuction(uint tripId) public{
        if(auctions[tripId].customerId != msg.sender)
            return revert();
        if(auctions[tripId].state !=1)
            return revert();

        auctions[tripId].state = 2;
        if(auctions[tripId].numBids == 0) {
            trips[tripId].state = TripState.abandoned;
            return;
        }

        trips[tripId].driver = auctions[tripId].minBidder;
        trips[tripId].amount = auctions[tripId].minBid;
        trips[tripId].state = TripState.driver_assigned;

        emit AuctionEnded(tripId);
        return;
    }

    function payForTheTrip(uint tripId, uint amount) public{
        require(amount == trips[tripId].amount);
        require(trips[tripId].state == TripState.driver_assigned);
        require(msg.sender == trips[tripId].customerId);

        trips[tripId].state = TripState.completed;
    }

    function bid(uint tripId, uint amount) public{
        require(amount > 0);
        require(auctions[tripId].state == 1);
        require(drivers[msg.sender].isRegistered == true);
        require(amount < auctions[tripId].minBid);

        auctions[tripId].minBidder = msg.sender;
        auctions[tripId].minBid    = amount;
        auctions[tripId].numBids   += 1;
    }

    function getTrip(uint _tripId) public view returns (
        uint tripId,
        string source,
        string destination,
        TripState state,
        address customerId,
        address driver,
        uint amount){

            require(trips[_tripId].customerId == msg.sender);

            return (
                trips[_tripId].tripId,
                trips[_tripId].source,
                trips[_tripId].destination,
                trips[_tripId].state,
                trips[_tripId].customerId,
                trips[_tripId].driver,
                trips[_tripId].amount
            );
        }
}
