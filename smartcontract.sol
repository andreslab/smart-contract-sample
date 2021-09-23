pragma solidity ^0.8.2;

//El nombre del token es el mismo del archio, es un estandart
contract Token {
    //* El uso de variables privadas solo se recomienda 
    //si tienes un nodo y quieres tener un valor en privado
    
    //* generalmente todas las variables y funciones 
    //son publicas porque cuando se publique en la blockchain 
    //se deja de tener acceso a la edicion del smartcontract y cualquiera puede hacer uso de el
    
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance; //generalmente se lo usa como las pool para delegar liquidez
    uint public totalSupply = 10000 * 10 ** 18;
    string public name = "My token";
    string public symbol = "AN";
    uint decimals = 18;
    
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    
    //msg.sender es la direccion del propietario del token
    constructor(){
        balances[msg.sender] = totalSupply;
    }
    
    //algunos nombres de funciiones son requerimientos de la documentacion, como balanceOf, transfer
    
    //las fucniones llevan "view" cuando la funcion es read-only o solo lectura y no modificara datos en la blockchain
    function balanceOf(address owner) public view returns(uint){
        return balances[owner];
    }
    //no lleva el view porque modificara datos en la blockchain
    function transfer(address to, uint value) public returns(bool){
        //se requiere que el valor que hay en la wallet que enviara los tokens tenga un valor igual o mayor al que se enviara
        require(balanceOf(msg.sender) >= value, 'balance too low');
        balances[to] += value;
        balances[msg.sender] -= value;
        emit Transfer(msg.sender, to, value);
        return true;
    }    
    
    function transferFrom(address from, address to, uint value) public returns(bool){
        require(balanceOf(from) >= value, 'balaance too low');
        require(allowance[from][msg.sender] >= value, 'allowance too low');
        balances[to] += value;
        balances[from] -= value;
        emit Transfer(from, to, value);
        return true;
    }
    
    function approve(address spender, uint value ) public returns(bool){
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
}