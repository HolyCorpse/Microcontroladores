;Projeto Contador 8 bits
;Autor : Roberto Marafon Leandro - 2158701
;Descrição: Contador Binario

;----------- Configuração do Fuse Bits -------------
__config _RC_OSC & _WDT_OFF &  _LVP_OFF & _DEBUG_OFF

;------------  Arquivos de Projeto  ----------------
#include <P16F877.INC>

;---------- Paginação de Memória de Dados ----------

BANK0 macro ;Seleciona Banco 0 da Memória
		BCF STATUS, RP0
		BCF STATUS, RP1
endm

BANK1 macro ;Seleciona Banco 1 da Memória
		BSF STATUS, RP0
		BCF STATUS, RP1
endm

BANK2 macro ;Seleciona Banco 2 da Memória
		BCF STATUS, RP0
		BSF STATUS, RP1
endm

BANK3 macro ;Seleciona Banco 3 da Memória
		BSF STATUS, RP0
		BSF STATUS, RP1
endm

;-------------------- Definicoes --------------------

#define ZB STATUS, Z ; Definindo o bit Z de STATUS como ZB
#define BOTAO PORTC, RC7 ; Pino RC7 do PORTC definido como BOTAO

;----------------- Vetor de Reset ---------------
	
	ORG 0X00
	goto INICIO

;--------------- Vetor de Interrupção -----------

	ORG 0X04
	retfie

;--------------- SUBROTINAS ---------------------

ATRASO: ; Funcao que consome ciclos de maquina
	MOVLW .255 ; Insere 255 ao WREG
	MOVWF TEMPO ; Insere o valor de WREG em TEMPO
AUX
	NOP ; Consome um ciclo de máquina
	NOP ; Consome um ciclo de máquina 
	DECFSZ TEMPO ; Decrementa TEMPO se ele for diferente de zero
	GOTO AUX ; Se tempo decrementou, voltamos para AUX
RETURN

CONTADOR: ; Unifica as funcoes para fazer o programa funcionar
	BTFSC BOTAO ; Checa o estado do pino PORTD, RD7
	CALL ADICIONAUM ; Se ZERO, chama a funcao ADICIONAUM
	BTFSS BOTAO ; Checa o estado do pino PORTD, RD7
	CALL ADICIONAZERO ; Se UM, chama a funcao ADICIONAZERO
	MOVLW 0XF0 ; Move 11110000 para o WREG
	BCF ZB ; Zera o STATUS, Z
	XORWF ARMAZENADOR,0 ; Faz um NAO EXCLUSIVO entre WREG e o ARMAZENADOR
	BTFSC ZB ; Se a operacao acima resultar em 00000000, o pino STATUS, Z
			 ; deve estar em ALTA. Assim, checamos esse pino.
	INCF PORTB,1 ; Se STATUS, Z estiver em ALTA é porque o usuario soltou o 
					; botao, logo, se incrementa PORTB
	CALL ATRASO ; Chama ATRASO para consumir clocks
	GOTO CONTADOR ; A funcao CONTADOR se chama para continuar o ciclo
RETURN

ADICIONAUM: ; Funcao que rotaciona bits para a esquerda e adiciona 1 no LSB
	RLF ARMAZENADOR,1
	MOVLW 0X01
	IORWF ARMAZENADOR,1
RETURN

ADICIONAZERO: ; Funcao que rotaciona bits para a esquerda e adiciona 0 no LSB
	RLF ARMAZENADOR,1
	MOVLW 0XFE
	ANDWF ARMAZENADOR,1
RETURN


;------------- Ínicio do Programa ------------- 

CBLOCK 0X20 ; Criacao de nomes para enderecos
	TEMPO ; 0x20
	ARMAZENADOR ; 0x21
ENDC

INICIO: 
		clrf PORTA ; Limpa os registradores para garantir que
		clrf PORTB ; não há informações remanescentes 
		clrf PORTC ; .
		clrf PORTD ; .
		clrf PORTE ; .
		clrf ARMAZENADOR ; Zera ARMAZENADOR
		

;------- Configuração de Entradas e Saídas ------

BANK1			;Move para o Banco 1 (Registradores TRIS)

		movlw 0xFF ; 0xFF - Configura todos os pinos como entradas com 
		movwf TRISA ; excecao dos pinos B, que serao saidas
		movlw 0x00 ; .
		movwf TRISB ; .
		movlw 0xFF ; .
		movwf TRISC ; .
		movlw 0xFF ; .
		movwf TRISD ; .
		movlw 0xFF ; .
		movwf TRISE ; .
		
BANK0 
		
;------------- Programa Principal ---------------

PRINCIPAL:
	CALL CONTADOR ; Chama CONTADOR
end