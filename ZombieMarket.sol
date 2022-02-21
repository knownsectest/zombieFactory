pragma solidity ^0.5.12;

import "./zombieOwnership.sol";

contract ZombeiMarket is ZombieOwnerShip{
    //1000 finney =1 ether;
    uint public tax =1 finney;
    uint public minPric =1 finney;
    //构造体
    struct zombieSales{
        //卖僵尸的人 涉及到钱的交易 
        address payable seller;

        //出售价格
        uint price;
    }

    //构造体创建映射，可以被外部查询
    mapping (uint => zombieSales) public zombieShop;

    //创建事件，如果有新僵尸放到市场触发
    event SaleZombie(uint indexed zombieID , address indexed seller);
    event BuyShopZombie(uint indexed zombieID , address indexed buyer, address indexed seller);
//onlyOwnerOf在僵尸助手里面 销售僵尸的合约
    function saleMyZombie(uint _zombieId , uint _price) public onlyOwnerOf(_zombieId){
        require(_price>=minPric +tax);
        //把构造体存放在映射里
        zombieShop[_zombieId] =zombieSales(msg.sender,_price);
        emit SaleZombie(_zombieId,msg.sender);
    }
//如何购买僵尸
    function buyShopZombie(uint _zombieId) public payable{
        //设置构造体
        zombieSales memory _zombieSales=zombieShop[_zombieId];
        require(msg.value>=_zombieSales.price);
        _transfer (_zombieSales.seller,msg.sender,_zombieId);
        //transfer内置的transfer方法
        _zombieSales.seller.transfer(msg.value-tax);
        delete zombieShop[_zombieId];
        emit BuyShopZombie(_zombieId,msg.sender,_zombieSales.seller);
    }
    //设置税金
    function setTax(uint _value) public onlyOwner{
      tax=_value;  
    }
    //设置最低售价函数
    function setMinPrice(uint _value) public onlyOwner{
        minPric=_value;
    }

}
