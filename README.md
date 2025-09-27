## Descripción del proyecto

El contrato KipuBank permite a un usuario almacenar y retirar fondos como un banco convencional.
Un usuario es capaz de depositar o retirar fondos de su bóveda, así como también ver la cantidad de fondos que posee.
También es posible observar la cantidad de depósitos y retiros históricos que realizó el banco.

## Guía de despliegue

1. Descargar el contracto de este repositorio.
2. Ir a Remix, un IDE para desarrollo de aplicaciones en la blockchain Ethereum: https://remix.ethereum.org/
3. Subir el contrato Remix, o pegarlo.
4. Compilar el contrato. Asociar tu cuenta de Metamask con Remix en caso de no haberlo heccho previamente.
5. Ir a la pestaña de "Deploy & Run transactions"
6. Elige tu cuenta de Metamask, en la red de Sepolia.
7. Establecer el valor de **maxWithdrawal** y seleccionar "Deploy"
8. Listo!

## Guía de usuario

Una vez desplegado, el usuario ya puede interactuar libremente con el contrato, teniendo una variedad de opciones para ello:
Para **depositar** es tan simple como enviar la cantidad a depositar al contrato en una transacción, teniendo en cuenta que el la boveda del usuario solo puede almacenar hasta 10000ETH.
Para **retirar** es primero necesario indicar la cantidad necesaria a retirar, teniendo en cuenta que no puede ser mayor al valor establecido en **maxWithdrawal** y no es posible retirar más fondos de los que posee el usuario en su boveda.
El usuario también puede consultar la cantidad de depositos y retiros que se hicieron al banco en su totalidad, mediante las funciones view **viewDeposits** y **viewWithdrawals**
El usuario también es capaz de consultar cuánto ETH tiene en su bóveda mediante la función view **viewVault**