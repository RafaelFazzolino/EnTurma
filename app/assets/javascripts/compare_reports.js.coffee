# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  clean_compare_reports = () ->
		$('a#clean_compare_reports').click((event) ->
     $('#compare_reports-container').empty().append(reportHTML)
     $('div#compare_reports-container').hide(); $('#clean_compare_reports').hide()
    )

  $("#new-request").on("ajax:success", (e, data, status, xhr) ->
  	$('#compare_reports-container').empty().append(compare_reportsHTML)
  	$("#compare_reports-result").show()
  	$("div#compare_reports-container").show(); $('#clean_compare_reports').show()

  	if data.first_report.ideb.status == "available"
      plotBar(formatIDEBDataToPlot(data.first_report.ideb.ideb, data.first_report.ideb.ideb_years,data.first_report.ideb.ideb_grade_ids), 'ideb-graph',["IDEB"],["#F4D03F"])
      appendAverageToDiv(data.first_report.ideb.ideb_average,"#average-ideb")
      appendStandardVariationToDiv(data.first_report.ideb.ideb_standard_deviation, "#standard-deviation-ideb")
      appendVarienceToDiv(data.first_report.ideb.ideb_variance, "#variance-ideb")
    else
      $("#ideb-compare_reports").empty()
      $("#ideb-compare_reports").removeClass('panel')
      $("#ideb-compare_reports").removeClass('panel-default')
      $("#ideb-compare_reports").addClass('alert alert-danger')
      $("#ideb-compare_reports").append("<strong>Desculpe!</strong> Mais não temos disponível dados do IDEB para essa turma.")



  	plotLine(formatDataToPlot(data.first_report.rates.evasion, data.first_report.year,data.first_report.grade), 'rate-evasion-graph',["Evasão"],["#FF5600"])
  	appendAverageToDiv(data.first_report.rates.evasion_average, '#average-evasion')
  	appendStandardVariationToDiv(data.first_report.rates.evasion_standard_deviation, '#standard-deviation-evasion')
  	appendVarienceToDiv(data.first_report.rates.evasion_variance, "#variance-evasion")

  	plotLine(formatDataToPlot(data.first_report.rates.performance, data.first_report.year,data.first_report.grade), 'rate-performance-graph', ["Performace"],["#0A62A4"])
  	appendAverageToDiv(data.first_report.rates.performance_average, '#average-perfomance')
  	appendStandardVariationToDiv(data.first_report.rates.performance_standard_deviation, '#standard-deviation-perfomance')
  	appendVarienceToDiv(data.first_report.rates.performance_variance, "#variance-perfomance")

  	plotLine(formatDataToPlot(data.first_report.rates.distortion, data.first_report.year,data.grade), 'rate-distortion-graph', ["Distorção"],["#FF5600"])
  	appendAverageToDiv(data.first_report.rates.distortion_average, '#average-distortion')
  	appendStandardVariationToDiv(data.first_report.rates.distortion_standard_deviation, '#standard-deviation-distortion')
  	appendVarienceToDiv(data.first_report.rates.distortion_variance, "#variance-distortion")

  ).on "ajax:error", (e, xhr, status, error) ->
    $("#row").append "<p>ERROR</p>"

appendAverageToDiv = (data,div) ->
	$(div).append "<span><b>Média</b> #{data.toFixed(2)}</span>"

appendStandardVariationToDiv = (data,div) ->
	$(div).append "<span><b>Desvio Padrão</b> #{data.toFixed(2)}</span>"

appendVarienceToDiv = (data,div) ->
	$(div).append "<span><b>Variância</b> #{data.toFixed(2)}</span>"


#Generic Method to plot an array of data at specific div
plotLine = (data,div,labels,colors) ->
	new Morris.Line({

		element: div,
		data: data,
		xkey: 'x'
		ykeys: ['y']
		labels: labels
		lineColors: colors
		})

plotBar = (data,div,labels,colors) ->
	new Morris.Bar({

		element: div,
		data: data,
		xkey: 'x'
		ykeys: ['y']
		labels: labels
		lineColors: colors
		})

#Method to format an array of data to a format that function plot needs
formatDataToPlot = (data, year, grade)->
	formatedData = []
	for value in data by 1
		formatedData.push {x: "#{year} - #{grade}° ano", y: value}
		year++
		grade++
	return formatedData

#Method to format an array of data to a format that function plot needs
formatIDEBDataToPlot = (data, years, grades)->
  formatedData = []
  i = 0
  for value in data by 1
    formatedData.push {x: "#{years[i]} - #{grades[i]}° ano", y: value}
    i++
  return formatedData


compare_reportsHTML = '
        <div id="compare_reports-result" style="display: none;">
         <div id="ideb-compare_reports" class="panel panel-default">
                <div class="panel-heading"><h4>Ideb</h4></div>
                <div id="panel-body-ideb" class="panel-body-ideb">
                    <div class="row">
                    </div>
                    <div class="row">
                        <div class="col-xs-6"><div id="ideb-graph"></div>
                            <div class="row">
                                <div id="ideb">
                                    <div id="average-ideb" class="col-xs-4"></div>
                                    <div id="standard-deviation-ideb" class="col-xs-4"></div>
                                    <div id="variance-ideb" class="col-xs-4"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-6">
                          <div id="ideb-graph-text">
                            <div class="description-col-md-6">
                            <p style="text-align: justify;"><font face="cursive"> &nbsp &nbsp &nbsp &nbsp
                                O Índice de Desenvolvimento da Educação Básica (Ideb) tem o objetivo de
                                reunir em um único indicador dois conceitos importantes para a qualidade
                                da educação: fluxo escolar e média de desempenho nas avaliações.
                                </font></p>

                            <p style="text-align: justify;"><font face="cursive"> &nbsp &nbsp &nbsp &nbsp
                             Ele agrega ao enfoque pedagógico dos resultados das avaliações em larga escala do
                             <a href="http://portal.inep.gov.br/" target="_blank">Inep</a>
                             a possibilidade de resultados sintéticos, facilmente assimiláveis, e que permitem
                             traçar metas de qualidade educacional para os sistemas. O indicador é calculado
                             a partir dos dados sobre aprovação, obtidos no Censo Escolar, e médias de desempenho
                             nas avaliações do Inep: o Seab (para unidades da federação e para o país) e a Prova
                             Brasil (para os municípios).</font></p>

                          </div>
                          </div>
                        </div>
                    </div>

                </div>
            </div>
            <br />
            <br />            <div class="panel panel-default">

                <div class="panel-heading"><h4>Índices</h4></div>
                <div class="evasion">
                <div class="panel-body">
                    <div class="row">

                        <h4>Evasão</h4>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                          <div id="rate-evasion-graph"></div>
                           <div class="rate-evasion">
                        <div id="rate-evasion">
                            <div id="average-evasion" class="col-xs-4"></div>
                            <div id="standard-deviation-evasion" class="col-xs-4"></div>
                            <div id="variance-evasion" class="col-xs-4"></div>
                        </div>
                    </div>
                        </div>
                        <div class="col-md-6">
                        <div id="rate-evasion-graph-text">
                        <div class="row">
                        <div id="rate-evasion">
                            <div id="average-evasion" class="col-xs-4"></div>
                            <div id="standard-deviation-evasion" class="col-xs-4"></div>
                            <div id="variance-evasion" class="col-xs-4"></div>
                        </div>
                        </div>
                        </div>
                          <div class="description-col-md-6">

                              <p style="text-align: justify;"><font face="cursive"> &nbsp &nbsp &nbsp &nbsp
                                O Índice de Evasão retrata o percentual de alunos que deixaram
                                de frequentar a escola, caracterizando dessa forma abandono escolar.</font></p>

                              <p style="text-align: justify;"><font face="cursive">  &nbsp &nbsp &nbsp &nbsp
                                Tal índice é obtido por meio do Censo Escolar pelo Inep e
                                compõe o Índice de Desenvolvimento da Educação Brasileira (Ideb).</font></p>

                          </div>
                          </div>
                    </div>
                  </div>
                </div>
                <div class="rendiment">
                <div class="panel-body">
                    <div class="row">
                        <h4>Redimento</h4>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                        <div id="rate-performance-graph-text">

                        </div>
                          <div class="description-col-md-6">
                            <p style="text-align: justify;"><font face="cursive"> &nbsp &nbsp &nbsp &nbsp
                                O Índice de Rendimento é baseado na Anresc. A Avaliação Nacional do Redimento
                                Escolar (Anresc) é uma avaliação criada pelo Ministério da Educação. Sendo
                                complementar ao Sistema Nacional de Educação Básica e um dos componentes para
                                o cálculo do Índice de Desenvolvimento da Educação Básica, a avaliação é realizada
                                a cada dois anos e participam todos os estudantes de escolas públicas urbanas do 5º
                                ao 9º ano em turmas com 20 ou mais alunos.</font></p>

                            <p style="text-align: justify;"><font face="cursive"> &nbsp &nbsp &nbsp &nbsp
                             A avaliação é dividida em duas provas: Língua Portuguesa e Matemática.</font></p>

                          </div>
                        </div>
                        <div class="col-md-6">
                        <div id="rate-performance-graph"></div>
                        <div class="rate-performance">
                         <div id="rate-performance">
                             <div id="average-perfomance" class="col-xs-4"></div>
                            <div id="standard-deviation-perfomance" class="col-xs-4"></div>
                            <div id="variance-perfomance" class="col-xs-4"></div>
                         </div>
                    </div></div>
                    </div>

                </div>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <h4>Distorção</h4>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                        <div id="rate-distortion-graph"></div>
                        <div class="rate-distortion">
                         <div id="rate-distortion">
                             <div id="average-distortion" class="col-xs-4"></div>
                            <div id="standard-deviation-distortion" class="col-xs-4"></div>
                            <div id="variance-distortion" class="col-xs-4"></div>
                         </div>
                        </div>
                        </div>
                        <div class="col-md-6"><div id="rate-distortion-graph-text"></div>
                          <div class="description-col-md-6">
                            <p style="text-align: justify;"><font face="cursive"> &nbsp &nbsp &nbsp &nbsp
                              O Índice de Distorção representa o percentual de alunos que se encontram em
                              condição de distorção idade-série.</font></p>
                            <p style="text-align: justify;"><font face="cursive"> &nbsp &nbsp &nbsp &nbsp
                              O aluno que reprova ou abandona os estudos por dois anos ou mais
                              durante a trajetória de escolarização, repetindo por consequência uma mesma
                              série, se encontra em defasem em relação à idade considerada adequada para
                              cada ano de estudo, de acordo com o que propõe a legislação educacional do
                              país. </font></p>
                            <p style="text-align: justify;"><font face="cursive"> &nbsp &nbsp &nbsp &nbsp
                            Neste caso o aluno será contabilizado na situação de distorção idade-série.</font></p>

                          </div>

                        </div>
                    </div>

                </div>
            </div>
        </div>'
