programa
{
	inclua biblioteca Arquivos --> arq
	inclua biblioteca Graficos --> g
	inclua biblioteca Teclado --> tcl
	inclua biblioteca Texto --> txt
	inclua biblioteca Tipos --> tp
	inclua biblioteca Util --> ut
	
	/*** VARIÁVEIS ***/
	/* Variáveis que determinam as telas */
	inteiro SAIR = 0, INICIO = 1, IDENTIFICACAO = 2, NOME_INVALIDO = 3, TEMAS = 4, REGRAS = 5, QUANTIDADE = 6,
		   QUANTIDADE_INVALIDA = 7, JOGO = 8, RESULTADO = 9, RESPOSTAS = 10, RANKING = 11, AVISO_RANKING = 12,
		   AVISO_APAGAR_RANKING = 13, ENCERRAR = 14, VERIFICA_ARQUIVO = 15, CREDITOS = 16
	inteiro tela_atual = INICIO
	
	/* Informações do jogador */
	//Nome do jogador
	cadeia nome_atual = ""
	//quantidade de perguntas que o jogador deseja responder
	inteiro quantidade_perguntas_selecionadas = 0
	//Tema escolhido pelo jogador
	inteiro tema_selecionado = 0
	//Vetor com as Respostas do jogador
	cadeia respostas_jogador[10]

	/* Variáeis utilizadas para escrever na tela */
	cadeia nome_jogador = ""
	cadeia qtd_perguntas = ""
	
	/* Variáveis perguntas */
	inteiro quantidade_perguntas_total = 0
	cadeia perguntas[100][7]
	// Índices coluna: 0 = Pergunta; 1 = Tema; 2 = Resposta correta; 3 a 6 = Alternativas
	inteiro PERGUNTA = 0, TEMA = 1, RESPOSTA_CORRETA = 2
	inteiro alt_A = 3, alt_B = 4, alt_C = 5, alt_D = 6
	
	/* Variáveis temas */
	//Nomes de todos os temas
	cadeia temas[10]
	//Todas as perguntas do tema escolhido
	cadeia perguntas_tema_selecionado[100][7]
	//Quantidade de temas total
	inteiro quantidade_temas_total = 0
	//Quantidade de perguntas do tema escolhido
	inteiro quantidade_perguntas_tema = 0
	
	/* Vetores com ordem normal e ordem aleatória de perguntas */
	inteiro ordem_aleatoria[10]

	/* Variáveis de resultado da pontuação do jogo atual e quantidade de acertos */
	inteiro pontuacao_atual = 0
	inteiro pontuacao_final = 0
	inteiro acertos = 0
	
	/* Vetores que guardam nomes e pontos do ranking */
	// Índices coluna: 0 = nome; 1 = pontuação
	inteiro NOME_RANKING = 0, PONTOS_RANKING = 1
	cadeia ranking[5][2] = {{"", "0"},
					    {"", "0"},
					    {"", "0"},
					    {"", "0"},
					    {"", "0"}}	


	/** Função inicial de telas do jogo **/		    
	funcao inicio()
	{
		inicializar()
		
		enquanto(tela_atual != SAIR)
		{
			escolha(tela_atual) 
			{
				caso INICIO:				tela_inicial()				pare
				caso IDENTIFICACAO:			tela_identificacao()		pare
				caso NOME_INVALIDO:			tela_nome_invalido()		pare	
				caso TEMAS:				tela_temas()				pare
				caso REGRAS: 				tela_regras()				pare
				caso QUANTIDADE:			tela_quantidade_perguntas()	pare
				caso QUANTIDADE_INVALIDA:	tela_quantidade_invalida()	pare
				caso JOGO:				tela_jogo()				pare
				caso RESULTADO:			tela_resultado()			pare
				caso RESPOSTAS:			tela_respostas()			pare
				caso RANKING:				tela_ranking()				pare						
				caso AVISO_RANKING:			tela_aviso_ranking()		pare	
				caso AVISO_APAGAR_RANKING:	tela_aviso_apagar_ranking()	pare
				caso ENCERRAR:				tela_encerramento()			pare
				caso VERIFICA_ARQUIVO:		tela_verifica_arquivo()		pare
				caso CREDITOS:				tela_creditos()			pare
			}
		}
		finalizar()
	}


	
	funcao inicializar() 
	{
		//Inicialização do modo gráfico
		g.iniciar_modo_grafico(verdadeiro)
		g.definir_dimensoes_janela(600, 600)
		g.definir_titulo_janela("QUIZ")

		//Leitura de arquivos e armazenamento de informações em matrizes e vetores
		quantidade_perguntas_total = armazena_perguntas()
		quantidade_temas_total = armazena_temas()
		armazena_ranking()
	}

	/* Leitura do arquivo e armazenamento de todas perguntas, temas, respostas corretas e alternativas em uma matriz */
	funcao inteiro armazena_perguntas() 
	{ 
		inteiro refArq, pos = 0
		cadeia linha
		
		refArq = arq.abrir_arquivo("./quiz.txt", arq.MODO_LEITURA)

		//Faz leitura até o final do arquivo
		enquanto (nao arq.fim_arquivo(refArq)) 
		{
			linha = arq.ler_linha(refArq)

			//Verifica se o arquivo possui no máximo 100 perguntas
			se(pos > 99) 
			{
				tela_atual = VERIFICA_ARQUIVO
				pare

			//Não faz leitura de linhas vazias
			} 
			senao se(txt.numero_caracteres(linha) != 0) 
			{
			inteiro inicial, tamanho, pipe
				
				inicial = 0
				tamanho = txt.numero_caracteres(linha)

				//Armazena as informações do arquivo em uma matriz
				//separando pergunta, tema, resposta correta e alternativas
				para (inteiro i = 0; i < ut.numero_colunas(perguntas); i++) 
				{
					cadeia bloco, elemento, info = ""
					pipe = txt.posicao_texto("|", linha, inicial)
					
					se (pipe > 0) 
					{
						bloco = txt.extrair_subtexto(linha, inicial, pipe)

						//Retira espaços antes e após "|", caso haja
						para (inteiro j = 0; j < txt.numero_caracteres(bloco); j++)
						{
							elemento = txt.extrair_subtexto(bloco, j, j + 1)
							se(j == 0 e elemento != " ")
							{
								info += elemento
							} 
							senao se (j > 0 e j < txt.numero_caracteres(bloco) - 1) 
							{
								info += elemento
							} 
							senao se (j == (txt.numero_caracteres(bloco) - 1) e elemento != " ") 
							{
								info += elemento
							}
						}
						perguntas[pos][i] = info
						
					} 
					senao //Última informação da linha do arquivo
					{
						bloco = txt.extrair_subtexto(linha, inicial, tamanho)

						//Retira espaços antes e após "|", caso haja
						para (inteiro j = 0; j < txt.numero_caracteres(bloco); j++)
						{
							elemento = txt.extrair_subtexto(bloco, j, j + 1)
							se(j == 0 e elemento != " ")
							{
								info += elemento
							} 
							senao se (j > 0 e j < txt.numero_caracteres(bloco) - 1) 
							{
								info += elemento
							} 
							senao se (j == (txt.numero_caracteres(bloco) - 1) e elemento != " ") 
							{
								info += elemento
							}
						}
						perguntas[pos][i] = info
					}
					inicial = pipe + 1
				}
				pos++
			}
		}
		arq.fechar_arquivo(refArq)
		retorne pos //Retorna a quantidade de perguntas total do arquivo
	}

	/* Armazena todos os temas do arquivo em um vetor */
	funcao inteiro armazena_temas() 
	{
		inteiro i = 0, pos = 0
		cadeia tema
		
		faca 
		{
			tema = perguntas[i][TEMA]

			se (nao (procura_temas(tema, temas))) 
			{
				temas[pos] = tema
				pos++
			}

			i++
			
		} 
		enquanto (perguntas[i][TEMA] != "")

		retorne (pos) //Retorna a quantidade de temas do arquivo
	}

	/* Verifica se o tema já existe no vetor "temas" */
	funcao logico procura_temas(cadeia tema, cadeia tm[]) 
	{
		para(inteiro i = 0; i < ut.numero_elementos(tm); i++) 
		{
			se(tm[i] == tema) 
			{
				retorne verdadeiro		
			}
		}
		retorne falso
	}

	/* Armazena na matriz "ranking" os resultados salvos, caso já tenha jogado pelo menos 1 vez */ 
	funcao armazena_ranking() 
	{
		inteiro refArq = 0, pos = 0
		cadeia linha

		//verifica se existe arquivo de resultados
		se (arq.arquivo_existe("./ranking_quiz.txt")) 
		{
			refArq = arq.abrir_arquivo("./ranking_quiz.txt", arq.MODO_LEITURA)

			enquanto(nao arq.fim_arquivo(refArq)) 
			{
				linha = arq.ler_linha(refArq)
	
				se (txt.numero_caracteres(linha) != 0) 
				{
					inteiro inicial, tamanho, pipe
	
					inicial = 0
					tamanho = txt.numero_caracteres(linha)
	
					pipe = txt.posicao_texto("|", linha, inicial)
								
						
					ranking[pos][0] = txt.extrair_subtexto(linha, inicial, pipe)
					ranking[pos][1] = txt.extrair_subtexto(linha, pipe + 1, tamanho)

					pos++
				}
			}			
			arq.fechar_arquivo(refArq)
		}
	}


	
	/*** Funções de fundo, imagem e formatação de texto ***/
	funcao desenhar_fundo() 
	{
		g.definir_cor(g.COR_BRANCO)
		g.limpar()
	}

	funcao formatar_texto() 
	{
		//Fonte do texto
		g.carregar_fonte("./assets/PressStart2P.ttf")
		g.definir_fonte_texto("Press Start 2P")
		//Cor do texto
		g.definir_cor(g.COR_PRETO)
	}

	funcao texto_grande_inicio() 
	{
		formatar_texto()
		g.definir_cor(g.COR_VERMELHO)
		g.definir_estilo_texto(falso, verdadeiro, falso)
		g.definir_tamanho_texto(22.0)
	}
	
	funcao texto_grande() 
	{
		formatar_texto()
		g.definir_estilo_texto(falso, verdadeiro, falso)
		g.definir_tamanho_texto(18.0)
	}

	funcao texto_medio() 
	{
		formatar_texto()
		g.definir_estilo_texto(falso, falso, falso)
		g.definir_tamanho_texto(14.0)
	}

	funcao texto_pequeno() 
	{
		formatar_texto()
		g.definir_estilo_texto(falso, falso, falso)
		g.definir_tamanho_texto(13.0)
	}

	/* Centraliza o texto */
	funcao inteiro centraliza(cadeia txt) 
	{
		inteiro centro

		centro = (600 - g.largura_texto(txt))/2
		
		retorne centro		
	}



	/* Tela de verificação da quantidade de perguntas do arquivo */
	funcao tela_verifica_arquivo() 
	{
		enquanto(tela_atual == VERIFICA_ARQUIVO) 
		{
			inteiro altura_texto[] = {200, 230}
			cadeia texto[] = {"O arquivo deve ter no", "máximo 100 perguntas!"}
			
			desenhar_fundo()
			desenhar_texto_verifica_arquivo(texto, altura_texto)
			
			g.renderizar() 

			tela_atual = SAIR
			ut.aguarde(3000)
		}
	}
	
	funcao desenhar_texto_verifica_arquivo(cadeia txt[], inteiro altura_txt[]) 
	{
		inteiro refImg = g.carregar_imagem("./logo_quiz_invalido.png")
		g.desenhar_imagem(250, 300, refImg)
		g.liberar_imagem(refImg)
		
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_retangulo(125, 170, 345, 100, falso, falso)

		texto_medio()
		para(inteiro i = 0; i < ut.numero_elementos(txt); i++)
		{
			g.desenhar_texto(centraliza(txt[i]), altura_txt[i], txt[i])
		}	
	}


	
	/* Tela inicial */
	funcao tela_inicial() 
	{
		enquanto(tela_atual == INICIO) 
		{
			inteiro altura_titulo = 200, altura_menu[] = {300, 360, 400, 440, 480}
			
			cadeia titulo = "QUIZ ADS 2021.2"
			cadeia menu[] = {
				"MENU",
				"[1] Jogar",
				"[2] Ranking",
				"[3] Créditos",
				"[ESC] Sair"
			}
			
			desenhar_fundo()
			desenhar_texto_inicial(titulo, menu, altura_titulo, altura_menu)

			g.renderizar()

			se (tcl.tecla_pressionada(tcl.TECLA_1) ou tcl.tecla_pressionada(tcl.TECLA_1_NUM)) 
			{
				opcao_inicial(titulo, menu, altura_titulo, altura_menu, 1)
				tela_atual = IDENTIFICACAO
				ut.aguarde(200)
			} 
			senao se (tcl.tecla_pressionada(tcl.TECLA_2) ou tcl.tecla_pressionada(tcl.TECLA_2_NUM)) 
			{
				opcao_inicial(titulo, menu, altura_titulo, altura_menu, 2)
				tela_atual = RANKING
				ut.aguarde(200)
			}
			senao se (tcl.tecla_pressionada(tcl.TECLA_3) ou tcl.tecla_pressionada(tcl.TECLA_3_NUM)) 
			{
				opcao_inicial(titulo, menu, altura_titulo, altura_menu, 3)
				tela_atual = CREDITOS
				ut.aguarde(200)
			} 
			senao se (tcl.tecla_pressionada(tcl.TECLA_ESC)) 
			{
				opcao_inicial(titulo, menu, altura_titulo, altura_menu, 4)
				tela_atual = ENCERRAR
				ut.aguarde(200)
			}
		}
	}
	
	funcao desenhar_texto_inicial(cadeia tit, cadeia mn[], inteiro altura_tit, inteiro altura_mn[]) 
	{
		inteiro refImg = g.carregar_imagem("./assets/logo_quiz.png")
		g.desenhar_imagem(225, 50, refImg)
		g.liberar_imagem(refImg)
		
		texto_grande_inicio()
		g.desenhar_texto(centraliza(tit), altura_tit, tit)

		texto_medio()
		g.desenhar_texto(centraliza(mn[0]), altura_mn[0], mn[0])

		texto_medio()
		para (inteiro i = 1; i < ut.numero_elementos(mn); i++) 
		{
			g.desenhar_texto(220, altura_mn[i], mn[i])		
		}	
	}

	funcao opcao_inicial(cadeia tit, cadeia mn[], inteiro altura_tit, inteiro altura_mn[], inteiro pos) 
	{
		desenhar_fundo()
		
		inteiro refImg = g.carregar_imagem("./assets/logo_quiz.png")
		g.desenhar_imagem(225, 50, refImg)
		g.liberar_imagem(refImg)
		
		texto_grande_inicio()
		g.desenhar_texto(centraliza(tit), altura_tit, tit)		

		texto_medio()
		g.desenhar_texto(centraliza(mn[0]), altura_mn[0], mn[0])
		
		texto_medio()
		para (inteiro i = 1; i < ut.numero_elementos(mn); i++) 
		{
			g.desenhar_texto(220, altura_mn[i], mn[i])	
		}

		//Mostra a opção selecionada
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_texto(178, altura_mn[pos], ">> ")

		g.renderizar()
	}



	/* Tela identificacao */
	funcao tela_identificacao() 
	{
		enquanto(tela_atual == IDENTIFICACAO) 
		{
			inteiro altura_titulo[] = {100, 150, 170}, altura_texto[] = {260, 340}, altura_menu = 460

			cadeia titulo[] = {
				"Bem-vindo ao jogo de perguntas e respostas!",
				"Você responderá as perguntas e",
				"saberá o quanto entende do assunto"
			}
			cadeia texto[] = {
				"Digite seu nome:",
				"xxxxx_"
			}
			cadeia menu = "[SHIFT] Continuar"
			
			inteiro tecla = tcl.ler_tecla()
			cadeia nome = texto[1]

			desenhar_fundo()
			desenhar_texto_identificacao(titulo, texto, menu, altura_titulo, altura_texto, altura_menu)

			g.renderizar()

			nome_atual = nome_jogador
			
			se (tecla == tcl.TECLA_SHIFT) 
			{		
				//Verifica se o nome não é vazio e tem menos que 2 letras
				se (nome_atual != "" e txt.numero_caracteres(nome_atual) > 2 )
				{
					opcao_identificacao(titulo, texto, menu, altura_titulo, altura_texto, altura_menu)
					nome_jogador = ""				
					tela_atual = TEMAS
					ut.aguarde(200)
				} 
				senao 
				{
					opcao_identificacao(titulo, texto, menu, altura_titulo, altura_texto, altura_menu)
					tela_atual = NOME_INVALIDO
					nome_jogador = ""
					ut.aguarde(200)					
				}				
			} 
			senao se ((tecla >= tcl.TECLA_A e tecla <= tcl.TECLA_Z) ou tecla == tcl.TECLA_BACKSPACE) 
			{		
				leitura_nome(tecla, texto)
				desenhar_nome(tecla, titulo, texto, menu, altura_titulo, altura_texto, altura_menu)

			} 
		}
	}
	
	funcao desenhar_texto_identificacao(cadeia tit[], cadeia txt[], cadeia mn, inteiro altura_tit[], inteiro altura_txt[], inteiro altura_mn) 
	{
		texto_pequeno()
		para (inteiro i = 0; i < ut.numero_elementos(tit); i++) 
		{
			g.desenhar_texto(centraliza(tit[i]), altura_tit[i], tit[i])		
		}
		
		texto_medio()
		g.desenhar_texto(centraliza(txt[0]), altura_txt[0], txt[0])		
		g.desenhar_texto(centraliza(txt[1]), altura_txt[1], nome_jogador + "_")

		texto_pequeno()
		g.desenhar_texto(centraliza(mn), altura_mn, mn)		
	}

	funcao leitura_nome(inteiro tcl, cadeia txt[]) 
	{
		cadeia nome = txt[1]
		inteiro tamanho = txt.numero_caracteres(nome_jogador)

		//grava letras digitadas
		se (tcl == tcl.TECLA_BACKSPACE) 
		{
			se (tamanho >= 1) 
			{
				nome_jogador = txt.extrair_subtexto(nome_jogador, 0, tamanho - 1)
			}
		} 
		senao se (tamanho + 1 <= 5) 
		{
			nome_jogador += tcl.caracter_tecla(tcl)
		}
	}

	/* mostra nome enquanto o jogador digita */
	funcao desenhar_nome(inteiro tcl, cadeia tit[], cadeia txt[], cadeia mn, inteiro altura_tit[], inteiro altura_txt[], inteiro altura_mn) 
	{
		cadeia nome = txt[1]

		desenhar_fundo()
		
		texto_pequeno()
		para (inteiro i = 0; i < ut.numero_elementos(tit); i++) 
		{
			g.desenhar_texto(centraliza(tit[i]), altura_tit[i], tit[i])		
		}
		
		texto_medio()
		g.desenhar_texto(centraliza(txt[0]), altura_txt[0], txt[0])		
		g.desenhar_texto(centraliza(nome), altura_txt[1], nome_jogador + "_")

		texto_pequeno()
		g.desenhar_texto(centraliza(mn), altura_mn, mn)

		g.renderizar()
	}
	
	funcao opcao_identificacao(cadeia tit[], cadeia txt[], cadeia mn, inteiro altura_tit[], inteiro altura_txt[], inteiro altura_mn) 
	{
		desenhar_fundo()

		texto_pequeno()
		para (inteiro i = 0; i < ut.numero_elementos(tit); i++) 
		{
			g.desenhar_texto(centraliza(tit[i]), altura_tit[i], tit[i])		
		}
		
		texto_medio()
		g.desenhar_texto(centraliza(txt[0]), altura_txt[0], txt[0])		
		g.desenhar_texto(centraliza(txt[1]), altura_txt[1], nome_jogador + "_")

		texto_pequeno()
		g.desenhar_texto(centraliza(mn), altura_mn, mn)
		
		//Mostra a opção selecionada
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_texto((centraliza(mn) - 39), altura_mn, ">> ")

		g.renderizar()
	}



	/* Tela nome inválido */
	funcao tela_nome_invalido() 
	{
		enquanto(tela_atual == NOME_INVALIDO) 
		{
			cadeia texto = "Nome inválido!", menu = "[BACKSPACE]"
			
			desenhar_fundo()
			desenhar_texto_nome_invalido(texto, menu)

			g.renderizar()
			
			se (tcl.tecla_pressionada(tcl.TECLA_BACKSPACE)) 
			{
				tela_atual = IDENTIFICACAO
				ut.aguarde(200)
			}
		}
	}
	
	funcao desenhar_texto_nome_invalido(cadeia txt, cadeia mn) 
	{
		inteiro refImg = g.carregar_imagem("./assets/logo_quiz_invalido.png")
		g.desenhar_imagem(250, 300, refImg)
		g.liberar_imagem(refImg)
		
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_retangulo(185, 170, 225, 100, falso, falso)

		texto_medio()
		g.definir_estilo_texto(falso, verdadeiro, falso)
		g.desenhar_texto(centraliza(txt), 200, txt)
		
		texto_medio()
		g.desenhar_texto(centraliza(mn), 240, mn)	
	}



	/* Tela de seleção de tema */
	funcao tela_temas() 
	{
		enquanto(tela_atual == TEMAS) 
		{
			inteiro altura_titulo = 140, altura_menu = 260
			cadeia titulo = "TEMAS"
			
			inteiro tecla = tcl.ler_tecla(), numero = 0
			caracter numero_caracter

			desenhar_fundo()
			desenhar_texto_temas(titulo, temas, altura_titulo, altura_menu)

			g.renderizar()
			
			se (tecla >= tcl.TECLA_0 e tecla <= tcl.TECLA_9)
			{	
				//Guarda o número do tema selecionado
				numero_caracter = tcl.caracter_tecla(tecla)
				tema_selecionado = tp.caracter_para_inteiro(numero_caracter)
				quantidade_perguntas_tema = total_perguntas_tema()
				
				opcao_temas(titulo, temas, altura_titulo, altura_menu, tema_selecionado)
				tela_atual = REGRAS
				ut.aguarde(200)
			}  
		}
	}
	
	funcao desenhar_texto_temas(cadeia tit, cadeia tm[], inteiro altura_tit, inteiro altura_mn) 
	{
		texto_grande()
		g.desenhar_texto(centraliza(tit), altura_tit, tit)		

		texto_medio()
		para (inteiro i = 0; i < ut.numero_elementos(tm); i++) 
		{
			se (tm[i] != "")
			{
				g.desenhar_texto((centraliza(tm[i]) - 30), altura_mn, "[" + i + "] " + tm[i])
				altura_mn += 40
			}		
		}	
	}

	funcao opcao_temas(cadeia tit, cadeia tm[], inteiro altura_tit, inteiro altura_mn, inteiro pos) 
	{	
		desenhar_fundo()
		
		texto_grande()
		g.desenhar_texto(centraliza(tit), altura_tit, tit)

		//Mostra a opção selecionada
		texto_medio()
		para (inteiro i = 0; i < ut.numero_elementos(tm); i++) 
		{
			se (tm[i] != "") 
			{
				g.definir_cor(g.COR_PRETO)
				g.desenhar_texto((centraliza(tm[i]) - 30), altura_mn, "[" + i + "] " + tm[i])
				
				se ((pos) == i)
				{
					g.definir_cor(g.COR_VERMELHO)
					g.desenhar_texto((centraliza(tm[pos]) - 72), altura_mn, ">> ")
				}
				altura_mn += 40
			}		
		}

		g.renderizar()
	}

	/* Armazena todas perguntas do tema escolhido em uma matriz */
	funcao inteiro total_perguntas_tema() 
	{
		inteiro j = 0, qtd = 0
		
		para (inteiro i = 0; i < quantidade_perguntas_total; i++)
		{
			se (perguntas[i][TEMA] == temas[tema_selecionado]) 
			{
				para (inteiro n = 0; n < 7; n++) 
				{
					perguntas_tema_selecionado[j][n] = perguntas[i][n]
				}
				j++
				qtd++
			}
		}
		retorne qtd
	}


	
	/* Tela de regras */
	funcao tela_regras() 
	{
		enquanto(tela_atual == REGRAS) 
		{
			inteiro altura_titulo[] = {140, 500}, altura_texto[] = {240, 270, 310, 340, 380, 410}

			cadeia titulo[] = {"REGRAS", "[ENTER]"}
			cadeia texto[] = {
				"1. Use as teclas A, B, C e D do", "teclado para responder;",
				"2. A cada 5 respostas certas você", "ganha +1 ponto de bônus;",
				"3. Cada AJUDA vale -1 ponto."
			}
			
			desenhar_fundo()
			desenhar_texto_regras(titulo, texto, altura_titulo, altura_texto)

			g.renderizar()
			
			se (tcl.tecla_pressionada(tcl.TECLA_ENTER)) 
			{
				opcao_regras(titulo, texto, altura_titulo, altura_texto)
				tela_atual = QUANTIDADE
				ut.aguarde(200)
			}
		}
	}
	
	funcao desenhar_texto_regras(cadeia tit[], cadeia txt[], inteiro altura_tit[], inteiro altura_txt[]) 
	{
		texto_grande()
		g.desenhar_texto(centraliza(tit[0]), altura_tit[0], tit[0])
		
		texto_pequeno()
		para (inteiro i = 0; i < ut.numero_elementos(txt); i++) 
		{
			g.desenhar_texto(centraliza(txt[i]), altura_txt[i], txt[i])		
		}

		texto_medio()
		g.desenhar_texto(centraliza(tit[1]), altura_tit[1], tit[1])
	}

	funcao opcao_regras(cadeia tit[], cadeia txt[], inteiro altura_tit[], inteiro altura_txt[]) 
	{
		desenhar_fundo()
		
		texto_grande()
		g.desenhar_texto(centraliza(tit[0]), altura_tit[0], tit[0])
		
		texto_pequeno()
		para (inteiro i = 0; i < ut.numero_elementos(txt); i++) {
			g.desenhar_texto(centraliza(txt[i]), altura_txt[i], txt[i])		
		}

		texto_medio()
		g.desenhar_texto(centraliza(tit[1]), altura_tit[1], tit[1])
		
		//Mostra a opção selecionada
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_texto((centraliza(tit[1]) - 42), altura_tit[1], ">> ")

		g.renderizar()
	}



	/* Tela de seleção da quantidade de perguntas */
	funcao tela_quantidade_perguntas() 
	{
		enquanto(tela_atual == QUANTIDADE) 
		{
			inteiro altura_titulo[] = {140, 400}, altura_texto[] = {260, 280, 320}
			cadeia titulo[] = {"QUANTIDADE DE PERGUNTAS", "[SHIFT] Continuar"}
			cadeia texto[] = {
				"Mínimo de 5 perguntas",
				"Máximo de 10 perguntas",
				"xx_"
			}

			cadeia qtd_atual = ""
			inteiro qtd_atual_num = 0
			cadeia qtd = texto[2]
			inteiro tecla2 = tcl.ler_tecla()
			
			desenhar_fundo()
			desenhar_texto_quantidade_perguntas(titulo, texto, altura_titulo, altura_texto)

			g.renderizar()
			
			qtd_atual = qtd_perguntas

			se (qtd_perguntas != "") 
			{
				qtd_atual_num = tp.cadeia_para_inteiro(qtd_perguntas, 10)
			}		
			
			se (tecla2 == tcl.TECLA_SHIFT) 
			{
				//impede que jogador entra vazio, número menor que 5 ou maior que a quantidade total de perguntas de um tema
				se (qtd_atual != "" e qtd_atual != "0" e qtd_atual != "1" e qtd_atual != "2" e qtd_atual != "3" e qtd_atual != "4" e qtd_atual_num <= quantidade_perguntas_tema)
				{
					quantidade_perguntas_selecionadas = tp.cadeia_para_inteiro(qtd_atual, 10)
					aleatorio()
					opcao_quantidade_perguntas(titulo, texto, altura_titulo, altura_texto)
					qtd_perguntas = ""
					desenhar_cronometro_inicial()
					tela_atual = JOGO
					ut.aguarde(200)
				} 
				senao 
				{
					opcao_quantidade_perguntas(titulo, texto, altura_titulo, altura_texto)
					tela_atual = QUANTIDADE_INVALIDA
					qtd_perguntas = ""
					ut.aguarde(200)					
				}				
			} 
			senao se ((tecla2 >= tcl.TECLA_0 e tecla2 <= tcl.TECLA_9) ou tecla2 == tcl.TECLA_BACKSPACE) 
			{
				leitura_quantidade_perguntas(tecla2, texto)
				desenhar_quantidade(tecla2, titulo, texto, altura_titulo, altura_texto)
			}
		}
	}
	
	funcao desenhar_texto_quantidade_perguntas(cadeia tit[], cadeia txt[], inteiro altura_tit[], inteiro altura_txt[]) 
	{
		texto_grande()
		g.desenhar_texto(centraliza(tit[0]), altura_tit[0], tit[0])		

		texto_medio()
		g.desenhar_texto(centraliza(txt[0]), altura_txt[0], txt[0])	
		g.desenhar_texto(centraliza(txt[1]), altura_txt[1], txt[1])
		g.desenhar_texto(centraliza(txt[2]), altura_txt[2], qtd_perguntas + "_")
		
		g.desenhar_texto(centraliza(tit[1]), altura_tit[1], tit[1])	
	}

	funcao leitura_quantidade_perguntas(inteiro tcl, cadeia txt[]) 
	{
		cadeia qtd = txt[2]
		inteiro tamanho = txt.numero_caracteres(qtd_perguntas)

		se (tcl == tcl.TECLA_BACKSPACE) 
		{
			se (tamanho >= 1) 
			{
				qtd_perguntas = txt.extrair_subtexto(qtd_perguntas, 0, tamanho - 1)
			}
		} 
		senao se (tamanho + 1 <= 2) 
		{
			qtd_perguntas += tcl.caracter_tecla(tcl)
		}
	}

	funcao desenhar_quantidade(inteiro tcl, cadeia tit[], cadeia txt[], inteiro altura_tit[], inteiro altura_txt[]) 
	{
		cadeia qtd = txt[2]

		desenhar_fundo()
		
		texto_grande()
		g.desenhar_texto(centraliza(tit[0]), altura_tit[0], tit[0])		

		texto_medio()
		g.desenhar_texto(centraliza(txt[0]), altura_txt[0], txt[0])	
		g.desenhar_texto(centraliza(txt[1]), altura_txt[1], txt[1])	
		g.desenhar_texto(centraliza(qtd), altura_txt[2], qtd_perguntas + "_")

		g.desenhar_texto(centraliza(tit[1]), altura_tit[1], tit[1])		

		g.renderizar()
	}
	
	funcao opcao_quantidade_perguntas(cadeia tit[], cadeia txt[], inteiro altura_tit[], inteiro altura_txt[]) 
	{	
		desenhar_fundo()

		texto_grande()
		g.desenhar_texto(centraliza(tit[0]), altura_tit[0], tit[0])		

		texto_medio()
		g.desenhar_texto(centraliza(txt[0]), altura_txt[0], txt[0])	
		g.desenhar_texto(centraliza(txt[1]), altura_txt[1], txt[1])	
		g.desenhar_texto(centraliza(txt[2]), altura_txt[2], qtd_perguntas + "_")

		g.desenhar_texto(centraliza(tit[1]), altura_tit[1], tit[1])	
		
		//Mostra a opção selecionada
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_texto((centraliza(tit[1]) - 42), altura_tit[1], ">> ")		

		g.renderizar()
	}

	/* Gera ordem aleatória de acordo com quantidade de pergunta selecionada */
	funcao aleatorio() 
	{		
		para (inteiro i = 0; i < ut.numero_elementos(ordem_aleatoria); i++) {
			ordem_aleatoria[i] = 0
		}

		inteiro pos = 0, num
		enquanto (nao (ordem_aleatoria[quantidade_perguntas_selecionadas - 1] != 0))
		{
			num = ut.sorteia(1, quantidade_perguntas_tema)
			se (nao procura_ordem(ordem_aleatoria, num))
			{
				ordem_aleatoria[pos] = num
				pos++
			}	
		}
	}

	/* Procura se o número já foi sorteado */
	funcao logico procura_ordem(inteiro ordem[], inteiro num) 
	{
		para(inteiro i = 0; i < ut.numero_elementos(ordem); i++) 
		{
			se(ordem[i] == num) 
			{
				retorne verdadeiro		
			}
		}
		retorne falso
	}

	funcao desenhar_cronometro_inicial ()
    	{    
     	inteiro contador = 3
     	cadeia txt = "O jogo vai começar...", cont
     	

   	 	enquanto (contador >= 0)
   	 	{
   		 	desenhar_fundo()
			inteiro refImg[] = {g.carregar_imagem("./assets/logo_quiz.png"), g.carregar_imagem("./assets/logo_quiz_2.png")}
			
			se (contador%2 != 0)
			{
				g.desenhar_imagem(225, 300, refImg[0])
				g.liberar_imagem(refImg[0])
			} 
			senao 
			{
				g.desenhar_imagem(225, 300, refImg[1])
				g.liberar_imagem(refImg[1])
			}
			
			texto_grande()
			g.desenhar_texto((centraliza(txt) - 20), 260, txt)

			cont = tp.inteiro_para_cadeia(contador, 10)
   		 	g.desenhar_texto(500, 260, cont)
   				  	 
   	  	 	contador = contador - 1
   	  	 	ut.aguarde(1000) // Aguarda 1000 millisegundos (1 segundo)	

   	  	 	g.renderizar()
   	 	}
      } 


	
	/* Tela de aviso de quantidade inválida */
	funcao tela_quantidade_invalida() 
	{
		enquanto(tela_atual == QUANTIDADE_INVALIDA) 
		{
			cadeia texto = "Quantidade inválida!", menu = "[BACKSPACE]"
			
			desenhar_fundo()
			desenhar_texto_quantidade_invalida(texto, menu)

			g.renderizar()
			
			se (tcl.tecla_pressionada(tcl.TECLA_BACKSPACE)) 
			{
				tela_atual = QUANTIDADE
				ut.aguarde(200)
			}
		}
	}
	
	funcao desenhar_texto_quantidade_invalida(cadeia txt, cadeia mn) 
	{
		inteiro refImg = g.carregar_imagem("./assets/logo_quiz_invalido.png")
		g.desenhar_imagem(250, 300, refImg)
		g.liberar_imagem(refImg)
		
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_retangulo(135, 170, 325, 100, falso, falso)

		texto_medio()
		g.definir_estilo_texto(falso, verdadeiro, falso)
		g.desenhar_texto(centraliza(txt), 200, txt)
		
		texto_medio()
		g.desenhar_texto(centraliza(mn), 240, mn)	
	}


	
	/* Tela do jogo */
	funcao tela_jogo() 
	{
		enquanto(tela_atual == JOGO) 
		{
			inteiro altura_titulo[] = {30, 100, 140}, altura_texto = 210, altura_alternativas[] = {280, 320, 360, 400}, altura_menu[] = {490, 510}
			inteiro linha = 0, pos = 0
			caracter alt_caracter
			inteiro tecla = 0, apagar_alternativa = 0

			faca 
			{
				linha = ordem_aleatoria[pos] - 1
				
				cadeia titulo[] = {
					"Pontos: " + pontuacao_atual,
					"Pergunta " + (pos + 1),
					"Tema: " + perguntas_tema_selecionado[linha][TEMA]
				}
				cadeia texto = perguntas_tema_selecionado[linha][PERGUNTA]
				cadeia alternativas[] = {
					"a) " +  perguntas_tema_selecionado[linha][alt_A],
					"b) " +  perguntas_tema_selecionado[linha][alt_B],
					"c) " +  perguntas_tema_selecionado[linha][alt_C],
					"d) " +  perguntas_tema_selecionado[linha][alt_D]
				}
				cadeia menu[] = {
					"[E] Eliminar alternativa",
					"[P] Pular"
				}

				//Se não tiver pontos, não aparecem as ajudas "eliminar alternativa" e "pular"
				se(pontuacao_atual == 0)
				{
					para(inteiro i = 0; i < ut.numero_elementos(menu); i++)
					{
						menu[i] = ""
					}
				}
			
				desenhar_fundo()
				desenhar_texto_jogo(titulo, texto, alternativas, menu, altura_titulo, altura_texto, altura_alternativas, altura_menu)
	
				se (tcl.tecla_pressionada(tcl.TECLA_A)) 
				{
					tecla = 0
					opcao_jogo(titulo, texto, alternativas, menu, altura_titulo, altura_texto, altura_alternativas, altura_menu, 0)
					alt_caracter = tcl.caracter_tecla(tcl.TECLA_A)					
					verificacao_resposta(alt_caracter, perguntas_tema_selecionado, linha, pos, ordem_aleatoria)
					pos++
					ut.aguarde(300)
				} 
				senao se (tcl.tecla_pressionada(tcl.TECLA_B)) 
				{
					tecla = 0
					opcao_jogo(titulo, texto, alternativas, menu, altura_titulo, altura_texto, altura_alternativas, altura_menu, 1)
					alt_caracter = tcl.caracter_tecla(tcl.TECLA_B)					
					verificacao_resposta(alt_caracter, perguntas_tema_selecionado, linha, pos, ordem_aleatoria)
					pos++
					ut.aguarde(300)
				} 
				senao se (tcl.tecla_pressionada(tcl.TECLA_C)) 
				{
					tecla = 0
					opcao_jogo(titulo, texto, alternativas, menu, altura_titulo, altura_texto, altura_alternativas, altura_menu, 2)
					alt_caracter = tcl.caracter_tecla(tcl.TECLA_C)					
					verificacao_resposta(alt_caracter, perguntas_tema_selecionado, linha, pos, ordem_aleatoria)
					pos++
					ut.aguarde(300)
				} 
				senao se (tcl.tecla_pressionada(tcl.TECLA_D)) 
				{
					tecla = 0
					opcao_jogo(titulo, texto, alternativas, menu, altura_titulo, altura_texto, altura_alternativas, altura_menu, 3)
					alt_caracter = tcl.caracter_tecla(tcl.TECLA_D)					
					verificacao_resposta(alt_caracter, perguntas_tema_selecionado, linha, pos, ordem_aleatoria)
					pos++
					ut.aguarde(300)
				} 
				senao se (tcl.tecla_pressionada(tcl.TECLA_E) e pontuacao_atual > 0) 
				{
					opcao_jogo(titulo, texto, alternativas, menu, altura_titulo, altura_texto, altura_alternativas, altura_menu, 4)
					apagar_alternativa = elimina_alternativa(linha)
					tecla = tcl.ler_tecla()
					pontuacao_atual -= 1
					ut.aguarde(300)
				} 
				senao se (tcl.tecla_pressionada(tcl.TECLA_P) e pontuacao_atual > 0) 
				{
					tecla = 0
					opcao_jogo(titulo, texto, alternativas, menu, altura_titulo, altura_texto, altura_alternativas, altura_menu, 5)
					respostas_jogador[pos] = ""
					pontuacao_atual -= 1
					pos++
					ut.aguarde(300)
				} 

				//Esconde alternativa eliminada na ajuda "eliminar alternativa"
				se(tecla == tcl.TECLA_E) 
				{
					g.definir_cor(g.COR_BRANCO)
					g.desenhar_retangulo(0, altura_alternativas[apagar_alternativa], 600, 40, falso, verdadeiro)	
				}
				
				g.renderizar()

			} enquanto(pos < quantidade_perguntas_selecionadas)

			//Ao fim do jogo, salva a pontuação, zera a variável que guarda os pontos durante o jogo e atualiza o ranking
			pontuacao_final = pontuacao_atual
			pontuacao_atual = 0
			atualiza_ranking(nome_atual, pontuacao_final)
			tela_atual = RESULTADO	
		}
	}

	funcao desenhar_texto_jogo(cadeia tit[], cadeia txt, cadeia alt[], cadeia mn[], inteiro altura_tit[], inteiro altura_txt, inteiro altura_alt[], inteiro altura_mn[]) 
	{	
		//Pontos, número da pergunta e tema
		texto_medio()
		para (inteiro i = 0; i < ut.numero_elementos(tit); i++) 
		{
			g.desenhar_texto(centraliza(tit[i]), altura_tit[i], tit[i])		
		}

		//enunciado
		desenhar_enunciado(txt, altura_txt)	
					

		//alternativas
		para (inteiro i = 0; i < ut.numero_elementos(alt); i++) 
		{	
			desenhar_alternativa(alt[i], altura_alt[i])				
		}
		
		//Ajuda
		texto_pequeno()
		para(inteiro i = 0; i < ut.numero_elementos(mn); i++)
		{
			g.desenhar_texto(130, altura_mn[i], mn[i])
		}
	}

	funcao opcao_jogo(cadeia tit[], cadeia txt, cadeia alt[], cadeia mn[], inteiro altura_tit[], inteiro altura_txt, inteiro altura_alt[], inteiro altura_mn[], inteiro pos) 
	{	
		desenhar_fundo()
		//Pontos, número da pergunta e tema
		texto_medio()
		para (inteiro i = 0; i < ut.numero_elementos(tit); i++) 
		{
			g.desenhar_texto(centraliza(tit[i]), altura_tit[i], tit[i])		
		}

		//enunciado
		desenhar_enunciado(txt, altura_txt)				

		//alternativas
		para (inteiro i = 0; i < ut.numero_elementos(alt); i++) 
		{	
			desenhar_alternativa(alt[i], altura_alt[i])				
		}

		//Ajuda
		texto_pequeno()
		para(inteiro i = 0; i < ut.numero_elementos(mn); i++)
		{
			g.desenhar_texto(130, altura_mn[i], mn[i])
		}

		//Mostra a opção selecionada
		se (pos != 4 e pos != 5) 
		{
			g.definir_cor(g.COR_VERMELHO)
			g.desenhar_texto(21, altura_alt[pos], ">> ")
		} 
		senao se(pos == 4) 
		{
			texto_pequeno()
			g.definir_cor(g.COR_VERMELHO)
			g.desenhar_texto(91, altura_mn[0], ">> ")			
		} 
		senao 
		{
			texto_pequeno()
			g.definir_cor(g.COR_VERMELHO)
			g.desenhar_texto(91, altura_mn[1], ">> ")
		}

		g.renderizar()
	}

	/* Separa o texto em pedaços menores */
	funcao organiza_texto(cadeia txt, cadeia vetor[]){
		cadeia palavra
		inteiro i = 0, comeco = 0, final, espaco, verifica = 0
		faca 
		{
			espaco = txt.posicao_texto(" ", txt, comeco)
			final = txt.numero_caracteres(txt)

			se (espaco > 0) 
			{
				palavra = txt.extrair_subtexto(txt, comeco, espaco + 1)
				vetor[i] += palavra					
				comeco = espaco + 1
			} 
			senao //guarda última palavra no vetor
			{
				palavra = txt.extrair_subtexto(txt, comeco, final)
				vetor[i] += palavra
				verifica = 1	
			}
		
			se (txt.numero_caracteres(vetor[i]) > 30)
			{
				i++
			}			
		} enquanto (verifica == 0)	
	}
	
	/* Organiza enunciado na tela */
	funcao desenhar_enunciado(cadeia txt, inteiro altura_txt)
	{
		//Organiza o enunciado da pergunta
		cadeia vetor[5] = {"", "", "", "", ""}
		inteiro y = (altura_txt - 30)
		
		organiza_texto(txt, vetor)	

		//desenha enunciado separado em pedaços
		para (inteiro i = 0; i < ut.numero_elementos(vetor); i++)
		{	
			se (vetor[i] != "")
			{
				texto_pequeno()
				g.desenhar_texto(centraliza(vetor[i]), y, vetor[i])
				y += 20
			}			
		}
	}

	/* Organiza alternativas grandes na tela */
	funcao desenhar_alternativa(cadeia txt, inteiro altura_txt)
	{
		//Organiza o enunciado da pergunta
		cadeia vetor[5] = {"", "", "", "", ""}
		
		organiza_texto(txt, vetor)	

		//desenha enunciado separado em pedaços
		para (inteiro i = 0; i < ut.numero_elementos(vetor); i++)
		{	
			se (vetor[i] != "")
			{
				texto_pequeno()
				g.desenhar_texto(60, altura_txt, vetor[i])
				altura_txt += 20
			}			
		}
	}
	
	/* verificação da resposta e contabilização de pontos */
	funcao verificacao_resposta(caracter alt, cadeia perg_tm[][], inteiro linha,inteiro pos, inteiro random[]) 
	{
		cadeia resp_atual = "", resp_correta

		escolha(alt) 
		{
			caso 'A':
				resp_atual = "1"
				respostas_jogador[pos] = tp.caracter_para_cadeia(alt)
				pare
			caso 'B':
				resp_atual = "2"
				respostas_jogador[pos] = tp.caracter_para_cadeia(alt)
				pare
			caso 'C':
				resp_atual = "3"
				respostas_jogador[pos] = tp.caracter_para_cadeia(alt)
				pare
			caso 'D':
				resp_atual = "4"
				respostas_jogador[pos] = tp.caracter_para_cadeia(alt)
				pare
		}

		resp_correta = perg_tm[linha][RESPOSTA_CORRETA]

		//Se a resposta do jogador for igual a correta, ganha +1 ponto
		se(resp_atual == resp_correta)
		{
			pontuacao_atual += 1
			acertos+= 1
		} 

		//Bônus a cada 5 respostas respondidas corretamente
		se (acertos%5 == 0 e acertos != 0)
		{
			pontuacao_atual += 1
		}
	}

	funcao inteiro elimina_alternativa(inteiro pos) 
	{
		inteiro alt, correta = 0, elimina = 0
		
		correta = tp.cadeia_para_inteiro(perguntas_tema_selecionado[pos][RESPOSTA_CORRETA], 10) - 1

		//sorteia uma alternativa que seja errada para eliminar
		faca 
		{
			alt = ut.sorteia(0, 3)
			se(alt != correta)
			{
				elimina = alt
			}
		} enquanto(alt == correta)
		retorne elimina
	}
	
	/* Atualiza com nome e pontuação do jogo atual a matriz do ranking */
	funcao atualiza_ranking(cadeia nome_novo, inteiro ponto_novo) 
	{
		cadeia nome_antigo
		inteiro ponto_antigo = 0
		
		para (inteiro i = 0; i < ut.numero_linhas(ranking); i++) 
		{
			nome_antigo = ranking[i][NOME_RANKING]
			ponto_antigo = tp.cadeia_para_inteiro(ranking[i][PONTOS_RANKING], 10)
			
			se (ponto_novo >= ponto_antigo ou (ponto_novo == 0 e ponto_antigo == 0))
			{
				ranking[i][NOME_RANKING] = nome_novo
				nome_novo = nome_antigo
				
				ranking[i][PONTOS_RANKING] = tp.inteiro_para_cadeia(ponto_novo, 10)
				ponto_novo = ponto_antigo
			}
		}
	}



	/* Tela de resultados */
	funcao tela_resultado() 
	{
		enquanto(tela_atual == RESULTADO) 
		{
			inteiro altura_texto[] = {140, 240, 280, 320, 360, 360}, altura_menu[] = { 470, 500, 530}		
			cadeia texto[] = {
				"RESULTADO",
				"Pontuação: " + pontuacao_final,
				"Tema: " + temas[tema_selecionado],
				"Quantidade de perguntas: " + quantidade_perguntas_selecionadas,
				"Erros: " + (quantidade_perguntas_selecionadas - acertos),
				"Acertos: " + acertos
			}
			cadeia menu[] = {
				"[1] Respostas",
				"[2] Ranking",
				"[BACKSPACE] Sair"
			}
			
			desenhar_fundo()
			desenhar_texto_resultado(texto, menu, altura_texto, altura_menu)

			g.renderizar()
			
			se (tcl.tecla_pressionada(tcl.TECLA_1) ou tcl.tecla_pressionada(tcl.TECLA_1_NUM)) 
			{
				opcao_resultado(texto, menu, altura_texto, altura_menu, 0)
				tela_atual = RESPOSTAS
				ut.aguarde(200)
			} 
			senao se (tcl.tecla_pressionada(tcl.TECLA_2) ou tcl.tecla_pressionada(tcl.TECLA_2_NUM)) 
			{
				opcao_resultado(texto, menu, altura_texto, altura_menu, 1)
				acertos = 0
				tela_atual = RANKING
				ut.aguarde(200)
			} 
			senao se (tcl.tecla_pressionada(tcl.TECLA_BACKSPACE)) 
			{
				opcao_resultado(texto, menu, altura_texto, altura_menu, 2)
				acertos = 0
				tela_atual = INICIO
				ut.aguarde(200)
			} 
		}
	}
	
	funcao desenhar_texto_resultado(cadeia txt[], cadeia mn[], inteiro altura_txt[], inteiro altura_mn[]) 
	{
		texto_grande()
		g.desenhar_texto(centraliza(txt[0]), altura_txt[0], txt[0])		
		
		texto_medio()
		para (inteiro i = 1; i < (ut.numero_elementos(txt) - 2); i++) 
		{
			g.desenhar_texto(centraliza(txt[i]), altura_txt[i], txt[i])		
		}

		g.desenhar_texto(180, altura_txt[4], txt[4])
		g.desenhar_texto(320, altura_txt[5], txt[5])

		para (inteiro i = 0; i < ut.numero_elementos(mn); i++) 
		{
			g.desenhar_texto(centraliza(mn[i]), altura_mn[i], mn[i])		
		}	
	}

	funcao opcao_resultado(cadeia txt[], cadeia mn[], inteiro altura_txt[], inteiro altura_mn[], inteiro pos) 
	{
		desenhar_fundo()
		
		texto_grande()
		g.desenhar_texto(centraliza(txt[0]), altura_txt[0], txt[0])		
		
		texto_medio()
		para (inteiro i = 1; i < (ut.numero_elementos(txt) - 2); i++) 
		{
			g.desenhar_texto(centraliza(txt[i]), altura_txt[i], txt[i])		
		}

		g.desenhar_texto(180, altura_txt[4], txt[4])
		g.desenhar_texto(320, altura_txt[5], txt[5])

		para (inteiro i = 0; i < ut.numero_elementos(mn); i++) 
		{
			g.desenhar_texto(centraliza(mn[i]), altura_mn[i], mn[i])		
		}

		//Mostra a opção selecionada
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_texto((centraliza(mn[pos]) - 42), altura_mn[pos], ">> ")		

		g.renderizar()
	}



	/* Tela de respostas */
	funcao tela_respostas() 
	{
		enquanto(tela_atual == RESPOSTAS) 
		{
			inteiro altura_titulo[] = {60, 520}, altura_texto = 110, altura_resposta = 130
			cadeia titulo[] = {"RESPOSTAS", "[BACKSPACE] Voltar"}
			
			desenhar_fundo()
			desenhar_texto_respostas(titulo, altura_titulo, altura_texto, altura_resposta)

			g.renderizar()
			
			se (tcl.tecla_pressionada(tcl.TECLA_BACKSPACE)) 
			{
				opcao_respostas(titulo, altura_titulo, altura_texto, altura_resposta)
				tela_atual = RESULTADO
				ut.aguarde(200)
			}
		}
	}
	
	funcao desenhar_texto_respostas(cadeia tit[], inteiro altura_tit[], inteiro altura_txt, inteiro altura_resp) 
	{
		texto_grande()
		g.desenhar_texto(centraliza(tit[0]), altura_tit[0], tit[0])
		
		texto_medio()
		g.desenhar_texto(centraliza(tit[1]), altura_tit[1], tit[1])
	
		texto_pequeno()
		para (inteiro i = 0; i < quantidade_perguntas_selecionadas; i++) 
		{
			se (i < 5) 
			{
				g.desenhar_texto(45, altura_txt, "Pegunta " + (i + 1))
				altura_txt += 80
			} 
			senao 
			{
				se (i == 5) 
				{
					altura_txt = 110
				}
				g.desenhar_texto(325, altura_txt, "Pegunta " + (i + 1))
				altura_txt += 80
			}						
		}

		inteiro linha = 0, resposta
		cadeia alternativas[] = {"A", "B", "C", "D"}
		
		para (inteiro pos = 0; pos < quantidade_perguntas_selecionadas; pos++) 
		{
			linha = ordem_aleatoria[pos] - 1
			resposta = tp.cadeia_para_inteiro(perguntas_tema_selecionado[linha][RESPOSTA_CORRETA], 10)

			texto_pequeno()
			se (pos < 5) 
			{
				g.desenhar_texto(45, altura_resp, "Resposta correta:" + alternativas[resposta - 1])
				g.desenhar_texto(45, altura_resp + 20, "Jogador:" + respostas_jogador[pos])
				altura_resp += 80
			} 
			senao 
			{	
				se (pos == 5) 
				{
					altura_resp = 130
				}
				g.desenhar_texto(325, altura_resp, "Resposta correta:" + alternativas[resposta - 1])
				g.desenhar_texto(325, altura_resp + 20, "Jogador:" + respostas_jogador[pos])
				altura_resp += 80
			}						
		}
	}

	funcao opcao_respostas(cadeia tit[], inteiro altura_tit[], inteiro altura_txt, inteiro altura_resp) 
	{	
		desenhar_fundo()
		
		texto_grande()
		g.desenhar_texto(centraliza(tit[0]), altura_tit[0], tit[0])
		
		texto_medio()
		g.desenhar_texto(centraliza(tit[1]), altura_tit[1], tit[1])
	
		texto_pequeno()
		para (inteiro i = 0; i < quantidade_perguntas_selecionadas; i++) 
		{
			se (i < 5) 
			{
				g.desenhar_texto(45, altura_txt, "Pegunta " + (i + 1))
				altura_txt += 80
			} 
			senao 
			{
				se (i == 5) 
				{
					altura_txt = 110
				}
				g.desenhar_texto(325, altura_txt, "Pegunta " + (i + 1))
				altura_txt += 80
			}						
		}

		inteiro linha = 0, resposta
		cadeia alternativas[] = {"A", "B", "C", "D"}
		
		para (inteiro pos = 0; pos < quantidade_perguntas_selecionadas; pos++) 
		{
			linha = ordem_aleatoria[pos] - 1
			resposta = tp.cadeia_para_inteiro(perguntas_tema_selecionado[linha][RESPOSTA_CORRETA], 10)

			texto_pequeno()
			se (pos < 5) 
			{
				g.desenhar_texto(45, altura_resp, "Resposta correta:" + alternativas[resposta - 1])
				g.desenhar_texto(45, altura_resp + 20, "Jogador:" + respostas_jogador[pos])
				altura_resp += 80
			} 
			senao 
			{	
				se (pos == 5) 
				{
					altura_resp = 130
				}
				g.desenhar_texto(325, altura_resp, "Resposta correta:" + alternativas[resposta - 1])
				g.desenhar_texto(325, altura_resp + 20, "Jogador:" + respostas_jogador[pos])
				altura_resp += 80
			}						
		}

		//Mostra a opção selecionada
		texto_medio()		
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_texto((centraliza(tit[1]) - 42), altura_tit[1], ">> ")	
		
		g.renderizar()
	}



	/* Tela de ranking */
	funcao tela_ranking() 
	{
		enquanto(tela_atual == RANKING) 
		{
			inteiro altura_titulo[] = {100, 480, 520}, altura_texto = 200
			cadeia titulo[] = {"RANKING", "[DEL] Apagar Ranking", "[BACKSPACE] Sair"}
			
			desenhar_fundo()
			desenhar_texto_ranking(titulo, altura_titulo, altura_texto)

			g.renderizar()

			gravar_resultado_ranking()
			
			se (tcl.tecla_pressionada(tcl.TECLA_DELETAR)) 
			{
				opcao_ranking(titulo, altura_titulo, altura_texto, 1)
				tela_atual = AVISO_RANKING
				ut.aguarde(200)
			} 
			senao se(tcl.tecla_pressionada(tcl.TECLA_BACKSPACE)) 
			{
				opcao_ranking(titulo, altura_titulo, altura_texto, 2)
				tela_atual = INICIO
				ut.aguarde(200)
			}
		}
	}
	
	funcao desenhar_texto_ranking(cadeia tit[], inteiro altura_tit[], inteiro altura_txt) 
	{
		texto_grande()
		g.desenhar_texto(centraliza(tit[0]), altura_tit[0], tit[0])
		
		texto_medio()
		para (inteiro i = 1; i < ut.numero_elementos(tit); i++) 
		{
			g.desenhar_texto(centraliza(tit[i]), altura_tit[i], tit[i])
		}
		
		cadeia pts
		
		texto_medio()
		para (inteiro i = 0; i < ut.numero_linhas(ranking); i++) 
		{
			nome_atual = txt.caixa_alta(ranking[i][NOME_RANKING])
			pts = ranking[i][PONTOS_RANKING]
			
			enquanto (txt.numero_caracteres(nome_atual) < 5) 
			{
				nome_atual += "."
			}
						
			ranking[i][NOME_RANKING] = nome_atual
			ranking[i][PONTOS_RANKING] = pts

			g.desenhar_texto(170, altura_txt, (i + 1) + ". " + nome_atual + "........." + pts + "\n")
			altura_txt += 40
		}	
	}

	funcao opcao_ranking(cadeia tit[], inteiro altura_tit[], inteiro altura_txt, inteiro pos) 
	{
		desenhar_fundo()
		
		texto_grande()
		g.desenhar_texto(centraliza(tit[0]), altura_tit[0], tit[0])

		texto_medio()
		para (inteiro i = 1; i < ut.numero_elementos(tit); i++) 
		{
			g.desenhar_texto(centraliza(tit[i]), altura_tit[i], tit[i])
		}
		
		cadeia pts
		
		texto_medio()
		para (inteiro i = 0; i < ut.numero_linhas(ranking); i++) 
		{
			nome_atual = txt.caixa_alta(ranking[i][NOME_RANKING])
			pts = ranking[i][PONTOS_RANKING]
			
			enquanto (txt.numero_caracteres(nome_atual) < 5) 
			{
				nome_atual += "."
			}
			
			ranking[i][NOME_RANKING] = nome_atual
			ranking[i][PONTOS_RANKING] = pts

			g.desenhar_texto(170, altura_txt, (i + 1) + ". " + nome_atual + "........." + pts + "\n")
			altura_txt += 40
		}	
		
		//Mostra a opção selecionada
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_texto((centraliza(tit[pos]) - 42), altura_tit[pos], ">> ")
		
		g.renderizar()
	}

	/* Grava o resultado do ranking em um arquivo */
	funcao gravar_resultado_ranking() 
	{
		inteiro refArq
		cadeia linha

		refArq = arq.abrir_arquivo("./ranking_quiz.txt", arq.MODO_ESCRITA)
		
		para (inteiro i = 0; i < ut.numero_linhas(ranking); i++) 
		{
			arq.escrever_linha(ranking[i][NOME_RANKING] + "|" + ranking[i][PONTOS_RANKING], refArq)
		}
		arq.fechar_arquivo(refArq)
	}



	/* Tela de aviso perguntando se deseja apagar ranking */
	funcao tela_aviso_ranking() 
	{
		enquanto(tela_atual == AVISO_RANKING) 
		{
			inteiro altura_texto = 180, altura_menu = 240
			cadeia texto[] = {"Deseja realmente", "apagar o ranking?"}, menu[] = {"[S] Sim", "[N] Não"}
			
			desenhar_fundo()
			desenhar_texto_aviso_ranking(texto, altura_texto, menu, altura_menu)

			g.renderizar()
			
			se (tcl.tecla_pressionada(tcl.TECLA_S)) 
			{
				apagar_ranking()
				tela_atual = AVISO_APAGAR_RANKING
				ut.aguarde(200)
			} 
			senao se(tcl.tecla_pressionada(tcl.TECLA_N)) 
			{
				tela_atual = RANKING
				ut.aguarde(200)
			}
		}
	}
	
	funcao desenhar_texto_aviso_ranking(cadeia txt[], inteiro altura_txt, cadeia mn[], inteiro altura_mn) 
	{
		desenhar_fundo()
		
		inteiro refImg = g.carregar_imagem("./assets/logo_quiz_aviso.png")
		g.desenhar_imagem(250, 320, refImg)
		g.liberar_imagem(refImg)
		
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_retangulo(140, 160, 310, 120, falso, falso)

		texto_medio()
		g.definir_estilo_texto(falso, verdadeiro, falso)
		para (inteiro i = 0; i < ut.numero_elementos(txt); i++) 
		{
			g.desenhar_texto(centraliza(txt[i]), altura_txt, txt[i])
			altura_txt += 20
		}

		texto_medio()
		g.desenhar_texto(180, altura_mn, mn[0])	
		g.desenhar_texto(320, altura_mn, mn[1])	
	}

	/* Limpa todos os resultados contidos na matriz "ranking" */
	funcao apagar_ranking() 
	{
		limpar_arquivo_ranking()
		
		para (inteiro i = 0; i < ut.numero_linhas(ranking); i++) 
		{
			//ﾃｭndice coluna 0 = nomes; 1 = pontuaﾃｧﾃｵes
			ranking[i][NOME_RANKING] = ""
			ranking[i][PONTOS_RANKING] = "0"
		}
	}

	/* Limpa o arquivo com o ranking */
	funcao limpar_arquivo_ranking() 
	{
		inteiro refArq
		cadeia linha

		refArq = arq.abrir_arquivo("./ranking_quiz.txt", arq.MODO_ESCRITA)
		
		arq.escrever_linha("", refArq)
		
		arq.fechar_arquivo(refArq)
	}



	/* Tela avisando que o ranking foi apagado */
	funcao tela_aviso_apagar_ranking() 
	{
		enquanto(tela_atual == AVISO_APAGAR_RANKING) 
		{
			inteiro altura_texto = 200, altura_menu = 240
			cadeia texto = "Ranking apagado!", menu = "[BACKSPACE]"
			
			desenhar_fundo()
			desenhar_texto_apagar_ranking(texto, altura_texto, menu, altura_menu)

			g.renderizar()
			
			se (tcl.tecla_pressionada(tcl.TECLA_BACKSPACE)) 
			{
				tela_atual = RANKING
				ut.aguarde(200)
			} 
		}
	}
	
	funcao desenhar_texto_apagar_ranking(cadeia txt, inteiro altura_txt, cadeia mn, inteiro altura_mn) 
	{
		inteiro refImg = g.carregar_imagem("./assets/logo_quiz_ok.png")
		g.desenhar_imagem(250, 300, refImg)
		g.liberar_imagem(refImg)
		
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_retangulo(165, 170, 265, 100, falso, falso)

		texto_medio()
		g.definir_estilo_texto(falso, verdadeiro, falso)
		g.desenhar_texto(centraliza(txt), altura_txt, txt)

		texto_medio()
		g.desenhar_texto(centraliza(mn), altura_mn, mn)	
	}



	/* Tela de encerramento */
	funcao tela_encerramento() 
	{
		enquanto(tela_atual == ENCERRAR) 
		{
			inteiro altura_texto = 210
			cadeia texto = "Até a próxima!"
			
			desenhar_fundo()
			desenhar_texto_encerramento(texto, altura_texto)
			
			g.renderizar() 

			tela_atual = SAIR
			ut.aguarde(500)
		}
	}
	
	funcao desenhar_texto_encerramento(cadeia txt, inteiro altura_txt) 
	{
		inteiro refImg = g.carregar_imagem("./assets/logo_quiz_ok.png")
		g.desenhar_imagem(250, 300, refImg)
		g.liberar_imagem(refImg)
		
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_retangulo(145, 170, 305, 100, falso, falso)

		texto_grande()
		g.desenhar_texto(centraliza(txt), altura_txt, txt)	
	}



	/* Tela de créditos */
	funcao tela_creditos() 
	{
		enquanto(tela_atual == CREDITOS) 
		{
			inteiro altura_titulo[] = {140, 500}, altura_texto[] = {260, 310, 360}

			cadeia titulo[] = {"CRÉDITOS", "[BACKSPACE] Sair"}
			cadeia texto[] = {
				"Bruna Silvestre do Nascimento",
				"Camilla Naomy Tsuda",
				"Mariana Borges Ramos"
			}
			
			desenhar_fundo()
			desenhar_texto_creditos(titulo, texto, altura_titulo, altura_texto)

			g.renderizar()
			
			se (tcl.tecla_pressionada(tcl.TECLA_BACKSPACE)) 
			{
				opcao_creditos(titulo, texto, altura_titulo, altura_texto)
				tela_atual = INICIO
				ut.aguarde(200)
			}
		}
	}
	
	funcao desenhar_texto_creditos(cadeia tit[], cadeia txt[], inteiro altura_tit[], inteiro altura_txt[]) 
	{
		texto_grande()
		g.desenhar_texto(centraliza(tit[0]), altura_tit[0], tit[0])
		
		texto_medio()
		para (inteiro i = 0; i < ut.numero_elementos(txt); i++) 
		{
			g.desenhar_texto(centraliza(txt[i]), altura_txt[i], txt[i])		
		}

		g.desenhar_texto(centraliza(tit[1]), altura_tit[1], tit[1])
	}

	funcao opcao_creditos(cadeia tit[], cadeia txt[], inteiro altura_tit[], inteiro altura_txt[]) 
	{
		desenhar_fundo()
		
		texto_grande()
		g.desenhar_texto(centraliza(tit[0]), altura_tit[0], tit[0])
		
		texto_medio()
		para (inteiro i = 0; i < ut.numero_elementos(txt); i++) {
			g.desenhar_texto(centraliza(txt[i]), altura_txt[i], txt[i])		
		}

		g.desenhar_texto(centraliza(tit[1]), altura_tit[1], tit[1])
		
		//Mostra a opção selecionada
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_texto((centraliza(tit[1]) - 42), altura_tit[1], ">> ")

		g.renderizar()
	}



	/* Finalização do modo gráfico */
	funcao finalizar() 
	{
		g.encerrar_modo_grafico()
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 48474; 
 * @DOBRAMENTO-CODIGO = [66, 97, 150, 174, 111, 202, 226, 239, 276, 282, 291, 299, 306, 313, 321, 333, 350, 369, 416, 465, 519, 535, 555, 577, 604, 623, 643, 672, 688, 717, 739, 766, 781, 806, 864, 877, 895, 914, 936, 955, 978, 983, 967, 1005, 1024, 1046, 1159, 1186, 1235, 1264, 1285, 1305, 1345, 1364, 1388, 1435, 1455, 1486, 1507, 1562, 1629, 1658, 1690, 1731, 1748, 1774, 1799, 1812, 1827, 1847, 1867, 1900, 1927, 1941, 1965];
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */