// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CarbonTracer {
    struct LifecycleStage {
        string stageName;
        uint256 carbonEmission; // 탄소배출량 (kg CO2e)
    }

    struct Product {
        string productName;
        string manufacturer;
        string productionDate;
        uint256 totalCarbonFootprint;
        LifecycleStage[] lifecycleStages;
    }

    mapping(uint256 => Product) public products;
    uint256 public productCount = 0;

    event ProductCreated(uint256 productId, string productName, string manufacturer);
    event LifecycleStageAdded(uint256 productId, string stageName, uint256 carbonEmission);

    // 새로운 제품을 등록하는 함수
    function createProduct(
        string memory _productName,
        string memory _manufacturer,
        string memory _productionDate
    ) public returns (uint256) {
        productCount++;
        Product storage newProduct = products[productCount];
        newProduct.productName = _productName;
        newProduct.manufacturer = _manufacturer;
        newProduct.productionDate = _productionDate;
        newProduct.totalCarbonFootprint = 0;

        emit ProductCreated(productCount, _productName, _manufacturer);
        return productCount;
    }

    // 제품의 라이프사이클 단계와 탄소 배출량을 추가하는 함수
    function addLifecycleStage(
        uint256 _productId,
        string memory _stageName,
        uint256 _carbonEmission
    ) public {
        Product storage product = products[_productId];
        product.totalCarbonFootprint += _carbonEmission;
        product.lifecycleStages.push(LifecycleStage(_stageName, _carbonEmission));

        emit LifecycleStageAdded(_productId, _stageName, _carbonEmission);
    }

    // 제품 정보를 가져오는 함수
    function getProduct(uint256 _productId)
        public
        view
        returns (
            string memory productName,
            string memory manufacturer,
            string memory productionDate,
            uint256 totalCarbonFootprint,
            uint256 lifecycleStageCount
        )
    {
        Product storage product = products[_productId];
        return (
            product.productName,
            product.manufacturer,
            product.productionDate,
            product.totalCarbonFootprint,
            product.lifecycleStages.length
        );
    }

    // 특정 제품의 라이프사이클 단계를 가져오는 함수
    function getLifecycleStage(uint256 _productId, uint256 _stageIndex)
        public
        view
        returns (string memory stageName, uint256 carbonEmission)
    {
        Product storage product = products[_productId];
        LifecycleStage storage stage = product.lifecycleStages[_stageIndex];
        return (stage.stageName, stage.carbonEmission);
    }
}
