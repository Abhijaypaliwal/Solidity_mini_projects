pragma solidity ^0.8.16;

contract enums {

    enum size {S,M,L,XL}
    enum progress{routine_creation, raw_material_production, delivery_to_warehouse, manufacturing, suppling_to_suppliers, complete}

    //size tshirtSize;
    address immutable owner;
    uint public routineNumber = 0;

    constructor() {
        owner = msg.sender;
    }

    progress mfgProgress;
    struct productionRoutine {
        uint routineNo;
        uint routineDateCreation;
        uint rawMaterialProdDate;
        uint deliveryToWarehouseDate;
        uint mfgDate;
        uint supplyDate;
        progress routineProgress;
    }

    productionRoutine NewProdRoutine;
    mapping(uint => productionRoutine) public mappingRoutine;

    modifier onlyOwner {
        require(msg.sender == owner, "user is not permitted");
        _;
    }

    //size constant defaultSize = size.L;

    function setRoutine() public onlyOwner{
        routineNumber++;
        NewProdRoutine = productionRoutine(routineNumber, block.timestamp,0,0,0,0,progress.routine_creation);
        mappingRoutine[routineNumber] = NewProdRoutine;

    }

    function CompleteRawMaterialProd(uint _routineNumber) public {
        require(mappingRoutine[_routineNumber].routineProgress != progress.raw_material_production && 
        mappingRoutine[_routineNumber].routineProgress != progress.delivery_to_warehouse &&
        mappingRoutine[_routineNumber].routineProgress != progress.manufacturing &&
        mappingRoutine[_routineNumber].routineProgress != progress.suppling_to_suppliers &&
        mappingRoutine[_routineNumber].routineProgress != progress.complete, "not allowed");
        productionRoutine memory prodr = mappingRoutine[_routineNumber];
        prodr.rawMaterialProdDate = block.timestamp;
        prodr.routineProgress =  progress.raw_material_production;
        mappingRoutine[_routineNumber] = prodr;

    }

    function CompleteDeliveryToWarehouse(uint _routineNumber) public {
        require(mappingRoutine[_routineNumber].routineProgress != progress.routine_creation && 
        mappingRoutine[_routineNumber].routineProgress != progress.delivery_to_warehouse &&
        mappingRoutine[_routineNumber].routineProgress != progress.manufacturing &&
        mappingRoutine[_routineNumber].routineProgress != progress.suppling_to_suppliers &&
        mappingRoutine[_routineNumber].routineProgress != progress.complete, "not allowed");
        productionRoutine memory prodr = mappingRoutine[_routineNumber];
        prodr.deliveryToWarehouseDate = block.timestamp;
        prodr.routineProgress =  progress.delivery_to_warehouse;
        mappingRoutine[_routineNumber] = prodr;

    }

    function CompleteMfg(uint _routineNumber) public {
        require(mappingRoutine[_routineNumber].routineProgress != progress.routine_creation &&
        mappingRoutine[_routineNumber].routineProgress != progress.raw_material_production &&
        mappingRoutine[_routineNumber].routineProgress != progress.manufacturing &&
        mappingRoutine[_routineNumber].routineProgress != progress.suppling_to_suppliers &&
        mappingRoutine[_routineNumber].routineProgress != progress.complete, "not allowed");
        productionRoutine memory prodr = mappingRoutine[_routineNumber];
        prodr.mfgDate = block.timestamp;
        prodr.routineProgress =  progress.manufacturing;
        mappingRoutine[_routineNumber] = prodr;

    }

    function CompleteSupply(uint _routineNumber) public {
        require(mappingRoutine[_routineNumber].routineProgress != progress.routine_creation && 
        mappingRoutine[_routineNumber].routineProgress != progress.raw_material_production &&
        mappingRoutine[_routineNumber].routineProgress != progress.complete &&
        mappingRoutine[_routineNumber].routineProgress != progress.suppling_to_suppliers &&
        mappingRoutine[_routineNumber].routineProgress != progress.delivery_to_warehouse, "not allowed");
        productionRoutine memory prodr = mappingRoutine[_routineNumber];
        prodr.supplyDate = block.timestamp;
        prodr.routineProgress =  progress.suppling_to_suppliers;
        mappingRoutine[_routineNumber] = prodr;

    }

}