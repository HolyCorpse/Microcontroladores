; LEDs piscando a cada 200ms
; Autor : Roberto Marafon Leandro - 2158701
; Descrição: Esse codigo considera um oscilador RC gerando uma frequencia
; de 20000 Hz
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

#define LED200 PORTB, RB7 ; Pino RB7 do PORTB definido como o LED que pisca a 200ms

;----------------- Vetor de Reset ---------------
	
	ORG 0X00
	goto INICIO

;--------------- Vetor de Interrupção -----------

	ORG 0X04
	retfie

;--------------- SUBROTINAS ---------------------

ATRASO: ; Funcao que consome ciclos de maquina
		; Esse codigo considera o valor de 20000 Hz, logo, cada ciclo
		; toma 1/(20000/4) segundos, ou seja, 200us
	MOVLW .100 ; Insere 100 ao WREG - 1 ciclo maquina
	MOVWF TEMPO ; Insere o valor de WREG em TEMPO - 1 ciclo maquina
	
AUX 
	NOP ; Consome um ciclo de maquina
	NOP ; Consome um ciclo de maquina 
	NOP ; Consome um ciclo de maquina
	NOP ; Consome um ciclo de maquina 
	NOP ; Consome um ciclo de maquina
	NOP ; Consome um ciclo de maquina
	DECFSZ TEMPO ; Decrementa TEMPO se ele for diferente de zero - 1 ciclo de maquina
	GOTO AUX ; Se tempo decrementou, voltamos para AUX - 2 ciclos de maquina
	MOVLW .30 ; Insere 30 ao WREG - 1 ciclo de maquina
	MOVWF TEMPO ; Insere WREG em TEMPO - 1 ciclo de maquina
	DECFSZ TEMPO ; Decrementa TEMPO se o resultado nao for zero - 1 ciclo
	GOTO $-1 ; Volta para a linha anterior - 2 ciclos
	MOVLW 0x80 ; Move o valor 0x80 pro WREG - 1 ciclo de maquina
	XORWF LED200 ; Alterna o valor de PORTB, RB7 - 1 ciclo de maquina
	NOP ; Consome um ciclo de maquina
	NOP ; Consome um ciclo de maquina
	GOTO ATRASO ; Vai para ATRASO - 2 ciclos de maquina
RETURN 

; A funcao ATRASO consome na parte antes de auxiliar 2 ciclos de maquina
; totais - 2*200us = 400us = 0.4ms.
; Na parte de AUX, consome 100*9*200us = 180000 us = 180ms - antes de 
; TEMPO == 0. Após isso, 1*200us + 1*200us + (1+2)*30*200us + 1*200us + 1*200us + 1*200us + 1*200us + 2*200us = 19600us = 19.6ms
; Total de tempo gasto por ATRASO = 0.4ms + 180ms + 19.6ms = 200ms.


;------------- Ínicio do Programa ------------- 

CBLOCK 0X20 ; Criacao de nomes para enderecos
	TEMPO ; 0x20
ENDC

INICIO: 
		clrf PORTA ; Limpa os registradores para garantir que
		clrf PORTB ; não há informações remanescentes 
		clrf PORTC ; .
		clrf PORTD ; .
		clrf PORTE ; .

;------- Configuração de Entradas e Saídas ------

BANK1			;Move para o Banco 1 (Registradores TRIS)

		movlw 0xFF ; 0xFF - Configura todos os pinos como entradas 
		movwf TRISA ; .
		movlw 0xFF ; .
		movwf TRISB ; .
		movlw 0xFF ; .
		movwf TRISC ; .
		movlw 0xFF ; .
		movwf TRISD ; .
		movlw 0xFF ; .
		movwf TRISE ; .

		BCF LED200 ; Define LED200 como saida
		
BANK0 
		
;------------- Programa Principal ---------------

PRINCIPAL:
	CALL ATRASO ; Chama ATRASO e consome 2 ciclos de maquina - 400us, porem, nao é
				; contabilizado na conta pois esse tempo nunca se repete
end