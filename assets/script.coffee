###
	      PALAVRAS CRUZADAS
	----------------------------
	Desenvolvido em CoffeeScript

		Código: Fabiane Lima
        Arte: Eduardo Stumpf
###

$ ->
	tempo = 60
	acertos = 0
	paused = false
	gameOn = false
	word = []
	letter = ''
	letterClass = ''
	count = 0
	fase = 0
	inter = null
	dicas =	[
				'<h2>Dica</h2><p>A marca ou produto é posicionado como líder em relação a __________ ou resultados para os clientes, como economia de tempo, redução de custo, conveniência ou melhoria de resultados.</p>'
				'<h2>Dica</h2><p>O posicionamento comunica que a marca ou produto é a que oferece aos consumidores potenciais a melhor relação ______ versus _________ ou o melhor valor.</p>'
				'<h2>Dica</h2><p>A performance das características específicas da marca ou do produto, tais como padrão de qualidade, competência do pessoal, criatividade, grau de flexibilidade ou condição de entrega.</p>'
				'<h2>Dica</h2><p>O produto ou marca é posicionado para uma categoria de _______ específica, como para professores universitários, associações de serviços ou indústrias de confecção de vestuário.</p>'
				'<h2>Dica</h2><p>O produto é posicionado como líder em uma _________ __ ________ determinada, como um parque temático de recreação ou serviços de atendimento médico.</p>'
				'<h2>Dica</h2><p>A marca ou produto é comparado como melhor em relação ao ___________, como a empresa mais comprometida com os clientes ou empresa mais premiada.</p>'
				'<h2>Dica</h2><p>Apresenta o produto como sendo o melhor para uma dada ocasião de ___ ou _________, como para épocas de demanda baixa ou situações de vendas decrescentes.</p>'
			]

	func =
		dismiss: ->
			paused = false
			$('.modal, .fade').fadeOut()

		help: ->
			paused = true
			$('.modal').html('<h1>Ajuda</h1><p>Clique no botão ‘COMEÇAR’ para iniciar o jogo. Clique na seta para ver a DICA. Você terá um tempo para responder cada afirmativa.</p><button class="ok">OK</button>')
			$('.modal, .fade').fadeIn()

		# Dá start no timer chamando a função cron(), pega o clique na seta e exibe a dica apropriada para aquela palavra.
		arrow: (arr) ->
			$('.hint').html(dicas[arr - 1])
			$('.l').css
				border: '2px solid #999'
				opacity: '0.6'
				cursor: 'auto'
			$('.l').removeClass('current')
			$('.w' + arr).addClass('current')
			$('.w' + arr).css
				border: '2px solid #6e4e94'
				opacity: '1'
				cursor: 'pointer'
			$('.a, .p' + arr).css('pointer-events','none')
			$('.p' + arr).removeClass('a')

			$('.w' + arr).each -> word.push $(this).html()
			$('.w' + arr).each -> if $(this).hasClass('y') then count++

			func.cron()

		# Se o jogo não estiver pausado, inicia o countdown e vai diminuindo o valor da variável tempo; se chegar a 0, zera o contador e encerra o setInterval().
		cron: ->
			fase++
			tempo = 60
			gameOn = true
			inter = setInterval ->
				if paused isnt true
					tempo--
					$('.timer').html(tempo)

					if tempo <= 0
						tempo = 0
						count = 0
						word = []
						gameOn = false

						clearInterval(inter)
						func.feedbackFinal()

						$('.timer').html(tempo)
						$('.a').css('pointer-events','auto')
						$('.modal').html('<h2>Acabou o tempo</h2><p>Não sobrou tempo para adivinhar essa palavra. Clique no botão abaixo para continuar a jogar</p><button class="ok">OK</button>')
						$('.modal, .fade').fadeIn()
						$('.hint').html('<h2>Mais sorte da próxima vez!</h2><p>Parece que não deu tempo de você adivinhar essa palavra. Clique em outra seta para continuar jogando.</p>')
			, 1000

		# Pega o conteúdo e a classe da letra clicada por parâmetro, pausa o timer, abre a janela para input do usuário, detecta qual a palavra em questão.
		entreLetra: (letra,classe) ->
			if gameOn is true
				if classe.split(' ').pop() is 'current'
					letter = letra
					letterClass = classe.slice(5,10)

					$('.modal').html('<h2>Letra</h2><p>Digite a letra correspondente ao quadro clicado no campo abaixo:</p><input type="text" maxlength="1" class="val"></input><br/><button class="verify">Enviar</button>')
					$('.modal, .fade').fadeIn()
					$('.val').focus()

		# Função chamada quando o usuário clica em OK para fechar o diálogo de input da letra. Restarta o timer, fecha o modal e compara a letra do input com a letra do campo.
		verify: (val) ->
			paused = false
			$('.modal,.fade').fadeOut()

			if letter is val
				$('.' + letterClass).addClass('y')
				$('.' + letterClass).css
					background: '#6e4e94'
					pointerEvents: 'none'
				count++
				func.feedbackWord()
			else
				setTimeout ->
					$('.modal').html('<h2>Letra errada</h2><p>Tente novamente!</p>')
					$('.modal, .fade').fadeIn().delay(2000).fadeOut()
				, 100

		feedbackWord: ->
			if word.length == count
				clearInterval(inter)
				acertos++
				count = 0
				word = []
				tempo = 0
				$('.a').css('pointer-events','auto')

				setTimeout ->
					if fase is 1 then $('.modal').html('<h2>Palavra correta</h2><p>Parabéns, você acertou 1 palavra!</p>')
					else $('.modal').html('<h2>Palavra correta</h2><p>Parabéns, você acertou ' + acertos + ' palavras!</p>')
					$('.modal, .fade').fadeIn().delay(2000).fadeOut()
					$('.hint').html('<h2>Muito bem!</h2><p>Você acertou uma das palavras. Agora clique em outra seta e continue a jogar.</p>')
				, 500

			func.feedbackFinal()

		feedbackFinal: ->
			if fase > 7 then fase = 7
			if fase is 7
				if tempo is 0
					setTimeout ->
						$('.modal').html('<h2>Fim de jogo</h2><p>Você acertou ' + acertos + ' palavras.</p><p>Para tentar mais uma vez, clique no botão abaixo.</p><button class="again">Jogar novamente</button>')
						$('.modal, .fade').fadeIn()
						$('.hint').html('<h2>Fim de jogo!</h2>')
					, 3500

	$(document).on 'click', '.start,.ok', -> 	func.dismiss()
	$(document).on 'click', '.help', -> 		func.help()
	$(document).on 'click', '.a', -> 			func.arrow(Number($(this).attr('class').slice(3)))
	$(document).on 'click', '.l', -> 			func.entreLetra($(this).html(),$(this).attr('class'))
	$(document).on 'click', '.verify', -> 		func.verify($('.val').val().toUpperCase())
	$(document).on 'click', '.again', ->		location.reload()
