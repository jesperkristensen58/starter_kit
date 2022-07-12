pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    uint public productCount = 0;
    mapping(uint => Product) public products;

    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    constructor() public {
        name = "Dapp University Marketplace";
    }

    function createProduct(string memory _name, uint _price) public {
        // Make sure parameters are correct
        require(bytes(_name).length > 0);
        require(_price > 0);
        
        productCount++;  // Increment product count
        products[productCount] = Product(productCount, _name, _price, msg.sender, false);  // create a new product
        emit ProductCreated(productCount, _name, _price, msg.sender, false);  // Trigger an event
    }

    function purchaseProduct(uint _id) public payable {
        // Fetch the product
        Product memory _product = products[_id];

        // Fetch the owner
        address payable _seller = _product.owner;
        // Make sure product is valid

        // require that the product has not been purchased
        require(_product.id > 0 && _product.id <= productCount);
        require(!_product.purchased);
        // require that the buyer is not the seller
        require(_seller != msg.sender);
        // require that there is enough ether in the transaction
        require(msg.value >= _product.price);
        
        // Transfer ownership to the buyer
        _product.owner = msg.sender;

        // Mark as purchased
        _product.purchased = true;
        
        // Update product in the mapping
        products[_id] = _product;

        // Pay the seller by sending them ether
        address(_seller).transfer(msg.value);

        // Trigger an event
        emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);
    }
}
