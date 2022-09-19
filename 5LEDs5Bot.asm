;Projeto Acende 5 LEDs com 5 Botões
;Autor : Roberto Marafon Leandro 2158701
;Descrição: Segunda Atividade

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

;-------- Definição das Entradas e Saídas -------

;-------------------- Saídas --------------------
#define LEDB7 PORTB, RB7 ; Definindo os pinos B7 a B3 como os LEDs do nosso trabalho
#define LEDB6 PORTB, RB6 ; 
#define LEDB5 PORTB, RB5 ; 
#define LEDB4 PORTB, RB4 ; 
#define LEDB3 PORTB, RB3 ; 

;------------------- Entradas -------------------
#define BOTC7 PORTC, RC7 ; Definindo os pinos C7 a C3 como os botoes do nosso trabalho
#define BOTC6 PORTC, RC6 ; 
#define BOTC5 PORTC, RC5 ; 
#define BOTC4 PORTC, RC4 ; 
#define BOTC3 PORTC, RC3 ; 

;----------------- Vetor de Reset ---------------
	
	ORG 0X00
	goto INICIO

;--------------- Vetor de Interrupção -----------

	ORG 0X04
	retfie
;--------------- Definindo Subrotinas -----------

CONTROLE_B7: ; Subrotina que relaciona o LEDB com o BOTC
	BTFSC BOTC7 ; Verifica se o BOTC esta em alta
	BSF LEDB7 ; Se sim, acende o LEDB
	BTFSS BOTC7 ; Verifica se o BOTC esta em baixa
	BCF LEDB7 ; Se sim, apaga o LEDB
return

CONTROLE_B6: ; Subrotina que relaciona o LEDB com o BOTC
	BTFSC BOTC6 ; Verifica se o BOTC esta em alta
	BSF LEDB6 ; Se sim, acende o LEDB
	BTFSS BOTC6 ; Verifica se o BOTC esta em baixa
	BCF LEDB6 ; Se sim, apaga o LEDB
return

CONTROLE_B5: ; Subrotina que relaciona o LEDB com o BOTC
	BTFSC BOTC5 ; Verifica se o BOTC esta em alta
	BSF LEDB5 ; Se sim, acende o LEDB
	BTFSS BOTC5 ; Verifica se o BOTC esta em baixa
	BCF LEDB5 ; Se sim, apaga o LEDB
return

CONTROLE_B4: ; Subrotina que relaciona o LEDB com o BOTC
	BTFSC BOTC4 ; Verifica se o BOTC esta em alta
	BSF LEDB4 ; Se sim, acende o LEDB
	BTFSS BOTC4 ; Verifica se o BOTC esta em baixa
	BCF LEDB4 ; Se sim, apaga o LEDB
return

CONTROLE_B3: ; Subrotina que relaciona o LEDB com o BOTC
	BTFSC BOTC3 ; Verifica se o BOTC esta em alta
	BSF LEDB3 ; Se sim, acende o LEDB
	BTFSS BOTC3 ; Verifica se o BOTC esta em baixa
	BCF LEDB3 ; Se sim, apaga o LEDB
return

;--------------- Ínicio do Programa ------------- 

INICIO: 
		clrf PORTA ; Limpar os registradores para garantir que não há informações  
		clrf PORTB ; remanescentes
		clrf PORTC ; .
		clrf PORTD ; .
		clrf PORTE ; .

;------- Configuração de Entradas e Saídas ------

BANK1 ; Move para o Banco 1 (Registradores TRIS)

		movlw H'FF' ; 0xFF - Configura todos os pinos como entradas
		movwf TRISA
		movlw H'FF' 
		movwf TRISB
		movlw H'FF' 
		movwf TRISC
		movlw H'FF' 
		movwf TRISD
		movlw H'FF' 
		movwf TRISE

		bcf TRISB, RB7 ; Define os pinos RB7 a RB3 como saídas
		bcf TRISB, RB6 ; .
		bcf TRISB, RB5 ; .
		bcf TRISB, RB4 ; .
		bcf TRISB, RB3 ; .

BANK0 ; Move para o Banco 0
		
;-------------- Programa Principal ---------------

PRINCIPAL:
 
		CALL CONTROLE_B7 ; Chama as subrotinas que relacionam os
		CALL CONTROLE_B6 ; os LEDs com os Botoes
		CALL CONTROLE_B5 ; .
		CALL CONTROLE_B4 ; .
		CALL CONTROLE_B3 ; .
		GOTO PRINCIPAL ;Retorna para PRINCIPAL para manter o ciclo de operacao

end