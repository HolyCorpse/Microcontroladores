;	Projeto Acender LED por botao
; 	Autor: Roberto Marafon Leandro
;	Descricaoo: Exempelo de projeto em Assembly
;	Para acender um LED por botao

; ------ Configura??o do Fuse Bits ---------------
__config _RC_OSC & _WDT_OFF & _LVP_OFF & _DEBUG_OFF

;----------- Arquivos de Projeto -----------------
#include <P16F877.INC>

;----------- Registradores de uso Geral ----------
;CBLOCK 0x20	;Posi??o inicia da mem?ria de dados 
;			;para uso geral
;	TEMPO
;endc
	
;-------------- Pagina??o de Mem?ria de Dados-------

BANK0 macro		;Seleciona Banco 0 da Mem?ria
				BCF STATUS, RP0
				BCF STATUS, RP1
		endm

BANK1 macro		;Seleciona Banco 1 da Mem?ria
				BSF STATUS, RP0
				BCF STATUS, RP1
		endm

BANK2 macro		;Seleciona Banco 2 da Mem?ria
				BCF STATUS, RP0
				BSF STATUS, RP1
		endm

BANK3 macro		;Seleciona Banco 3 da Mem?ria
				BSF STATUS, RP0
				BSF STATUS, RP1
		endm


;----------	Defini??o das Entradas e Sa?das -----------------

;-----------------------	Sa?das	-------------------------
#define 	LED 	PORTB,RB7 	
#define 	BOTAO   PORTB, RB6

;------------------	Vetor de Reset  ------------------------

	ORG 0x00
	goto	INICIO

;---------------- Vetor de Interrup??o ---------------------

	ORG 0x04
	retfie

;--------------------- Subrotinas --------------------------

;ATRASO:
;		movlw	.255	;Inicia a contagem
;		movwf	TEMPO	;Registrador para auxiliar a contagem
;		decfsz	TEMPO	;Decrementa Tempo e Pula se Zero
;		goto    $-1		;Volta para linha anterior
;return

;----------------- In?cio do Programa ---------------------- 

INICIO:
		clrf	PORTA;Limpar os Resgistradores para garantir
		clrf	PORTB;que n?o h? informa??es remanescentes
		clrf	PORTC
		clrf	PORTD
		clrf	PORTE

;-----------	Configura??o de Entradas e Sa?das ----------

BANK1			;Move para o Banco 1 (Registradores TRIS)

		movlw	H'FF'	;Configura todos os Pinos como entradas
		movwf	TRISA
		movlw	H'FF'
		movwf	TRISB
		movlw	H'FF'
		movwf	TRISC
		movlw	H'FF'
		movwf	TRISD
		movlw	H'FF'
		movwf	TRISE


 		bcf		TRISB,RB7

BANK0

;----------------- Programa Principal ------------------

PRINCIPAL:

		btfsc	BOTAO 			;Teste: O Botao esta pressionado?
		goto	LIGAR_LED		;Sim, Entao liga o LED
		goto	DESLIGAR_LED	;Nao, Entao desliga o LED

DESLIGAR_LED:
		bcf		LED
		goto 	PRINCIPAL

LIGAR_LED:
		bsf		LED
		goto 	PRINCIPAL

end