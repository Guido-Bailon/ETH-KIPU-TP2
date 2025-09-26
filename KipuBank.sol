// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;

contract KipuBank{
    /*///////////////////////
					Variables
	///////////////////////*/
    ///@notice constante que indica el maximo valor almacenable de eth para cada usuario
    uint256 constant MAX_VAULT = 10000;
    ///@notice variable inmutable que indica la maxima cantidad de eth que pueden retirarse en una unica transaccion
    uint256 immutable i_maxWithdrawal;
    ///@notice variable utilizada para almacenar la boveda de cada usuario
    mapping(address user => uint256 vault) private s_vaults;
    ///@notice variable que almacena la cantidad total de depositos
    uint256 private s_deposits;
    ///@notice variable que almacena la cantidad total de retiros
    uint256 private s_withdrawals;

    
    /*///////////////////////
					Events
	///////////////////////*/
    ///@notice evento emitido cuando un usuario realiza un deposito correctamente
    event KipuBank_deposit(address user, uint256 value);
    ///@notice evento emitido cuando un usuario realiza un retiro correctamente
    event KipuBank_withdrawal(address user, uint256 value);
    
    /*///////////////////////
					Errors
	///////////////////////*/
    ///@notice error emitido cuando un usuario quiere depositar y fuera a superar el maximo de su boveda
    error KipuBank_bankCapped(address caller);
    ///@notice error emitido cuando un usuario quiere retirar mas fondos de los que posee en su boveda
    error KipuBank_unsuficentFunds(address caller);
    ///@notice error emitido cuando un usuario quiere retirar mas fondos de lo permitido por el banco
    error KipuBank_withdrawalCapped(address caller);
    
    /*///////////////////////
					Functions
	///////////////////////*/

    constructor(uint256 maxWithdrawal){
        i_maxWithdrawal = maxWithdrawal;
    }

    receive() external payable {}
    fallback() external payable{}

    function deposit() external payable {
        if (msg.value + s_vaults[msg.sender] > MAX_VAULT) revert KipuBank_bankCapped(msg.sender);
        s_vaults[msg.sender] +=  msg.value;
        s_deposits += 1;
        emit KipuBank_deposit(msg.sender,msg.value);
    }

    function withdrawal(uint256 quant) external{

    }
}