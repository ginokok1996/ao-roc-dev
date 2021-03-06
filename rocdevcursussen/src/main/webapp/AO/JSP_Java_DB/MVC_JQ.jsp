
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/includes/pagetop-all.jsp"%>
<div class="container">
	<%@ include file="/AO/JSP_Java_DB/includes/zijmenu.jsp"%>
	<div class="col-md-9">
		<h2>MVC en Servlets</h2>

		<!-- Leerdoelen -->
		<div class="bs-callout bs-callout-warning">
			<h2>Leerdoelen</h2>
			<p>Na het bestuderen van dit hoofdstuk wordt van je verwacht dat
				je de volgende begrippen kent en kunt gebruiken:</p>
			<ul>
				<li>het MVC ontwerppatroon</li>
				<li>java servlets</li>
				<li>JavaBeans</li>
				<li>Expression Language (EL)</li>
			</ul>
		</div>

		<!-- inhoud -->
		<p>
			In het veelgebruikte <a
				href="http://nl.wikipedia.org/wiki/Model-view-controller-model"
				target="_blank"> Model View Controller</a> ontwerppatroon wordt
			onderscheid gemaakt tussen verschillende lagen in je applicatie.
		</p>
		<img src="<c:url value="/AO/JSP_Java_DB/images/mvc.png"/>" alt="mvc patroon">
		<p>
			Onderstaande afbeelding toont de structuur van het project uit deel 4
			opgezet volgens het mvc patroon. De broncode van het project met
			zowel een Datastore als een MySQL databaseklasse kun je <a
				href="https://github.com/pieeet/sport-cloudsql" target="_blank">hier</a>
			vinden.
		</p>
		<img src="<c:url value="/AO/JSP_Java_DB/sport_db_project.png"/>" alt="">
		<h3>Data laag (package sportIO)</h3>
		<p>Bevat klasse(n) die connectie maakt/maken met de database en
			alle transacties met database afhandelt. Indien een andere database
			moet worden ge&iuml;mplementeerd, hoeft alleen deze klasse te worden
			aangepast. Dat maakt een applicatie een stuk gemakkelijker
			onderhoudbaar.</p>
		<h3>Model laag (package sport)</h3>
		<p>Bevat de &quot;business&quot; of &quot;domein&quot; klassen. De
			kern van de applicatie. De baas van de model laag in dit voorbeeld is
			de klasse Administratie. Deze heeft toegang tot de andere klassen in
			de package en krijgt een instantie van SportIO die de connectie met
			de data-laag tot stand brengt.</p>

		<pre class="code">
import <span class="codeplus">sportIO.SportIO</span>;

public class Administratie {
	private <span class="codeplus">SportIO io</span>;
	private ArrayList&lt;Lid&gt; leden;
	private ArrayList&lt;Team&gt; teams;
	private boolean ledenIsLeeg;
	private boolean teamsIsLeeg;
	
	public Administratie() {
		<span class="codeplus">io = new SportIO()</span>;
		leden = <span class="codeplus">io</span>.getLedenLijst();
		if (leden.isEmpty())
		    ledenIsLeeg = true;
		teams = <span class="codeplus">io</span>.getTeamLijst();
		if (teams.isEmpty())
		    teamsIsLeeg = true;
	}
	....
</pre>

		<h3>Control laag (package control)</h3>
		<p>De control-laag bestaat uit Servlets die het verkeer tussen
			gebruiker, de model-laag en de views regelt. Er is geen directe
			connectie tussen control-laag en data-laag. Dat verloopt via de
			model-laag.</p>
		<img src="<c:url value="/AO/JSP_Java_DB/images/servlet.jpg"/>">
		<p>De servlet in ons voorbeeld krijgt een object van het type
			Administratie die de connectie met de model-laag en de data-laag tot
			stand brengt.</p>


		<pre class="code">
public class SportServlet extends HttpServlet {
	private Administratie admin;
	....
</pre>

		<h4>Methodes van Servlets</h4>
		<p>Onderstaande twee methodes worden altijd ge&iuml;mplementeerd
			en handelen de get en post requests af die door gebruiker zijn
			verstuurd. Vaak wordt &eacute;&eacute;n van de twee methodes gebruikt
			om alle code te schrijven en wordt de ander hiernaar doorverwezen
			(zie voorbeeld). Je hoeft je dan geen zorgen meer te maken over
			wanneer methode get en wanneer methode post wordt gebruikt.</p>

		<pre class="code">		   
<b><span class="codeplus">doGet</span></b>(HttpServletRequest <span
				class="codeplus">req</span>, HttpServletResponse <span
				class="codeplus">resp</span>) {
    <span class="comment">//alle benodigde code</span>
}
<b><span class="codeplus">doPost</span></b>(HttpServletRequest <span
				class="codeplus">req</span>, HttpServletResponse <span
				class="codeplus">resp</span>) {
    <span class="comment">//stuur door naar doGet</span>
    doGet(<span class="codeplus">req</span>, <span class="codeplus">resp</span>)
}
</pre>

		<p>Binnen doGet of doPost kan met de methode getParameter van het
			Request object de parameters met een bepaalde naam worden opgehaald.</p>

		<pre class="code">		   
<b>req.getParameter</b>(&quot;naam van parameter&quot;);
</pre>

		<p>voorbeeld</p>

		<pre class="code">		   
if (req.getParameter(&quot;knopNieuwLid&quot;) != null) {
    <span class="comment">// doe iets</span>
}
</pre>
		<p>Als de servlet zijn taken heeft uitgevoerd kan hij de gebruiker
			terug- of doorsturen naar een html/jsp pagina of servlet met
			sendRedirect(&quot;url&quot;).</p>


		<pre class="code">		   
if (req.getParameter(&quot;knopNieuwLid&quot;) != null) {
    <span class="comment">// roept hulpmethode aan die een nieuw lid toevoegt...</span>
    this.voegNieuwLidToe(req, resp);
    <span class="comment">//... en stuurt gebruiker (terug) naar doelpagina</span>
    <span class="codeplus">resp.sendRedirect</span>(&quot;/index.jsp&quot;);
}
</pre>
		<p>Ook kan de servlet met de methode setAttribute() een attribuut
			aan het request meegeven. Deze wordt vervolgens doorgestuurd naar een
			doelpagina (jsp of servlet) die dit attribuut kan gebruiken.</p>

		<pre class="code">		   
req.setAttribute(&quot;&lt;naam attribuut&gt;&quot;, object);
</pre>

		<p>
			In een dergelijk geval moet het request worden &quot; <a
				href="https://translate.google.nl/#en/nl/dispatch" target="_blank">gedispatched</a>&quot;.
			Hiervoor heb je een Dispatcher object nodig. Voorbeeld:
		</p>

		<pre class="code">
Lid lid = admin.getLid(req.getParameter(&quot;spelerscode&quot;))		   
req.setAttribute(&quot;lid&quot;, lid);
<span class="codeplus">RequestDispatcher disp = getServletContext()</span>
    <span class="codeplus">.getRequestDispatcher(&quot;/wijziglid.jsp&quot;)</span>;
try {
	<span class="codeplus">disp.forward(req, resp)</span>;
} catch (ServletException e) {
	e.printStackTrace();
}
</pre>
		<p>In de doelpagina (jsp of servlet) kan het attribuut vervolgens
			worden opgevraagd met de methode request.getAttribute(naam
			attribuut). Het object &quot;lid&quot; dat in het vorige code
			fragment als attribuut is meegegeven kan in de jsp pagina
			(wijziglid.jsp) met de volgende &quot;scriptlet&quot; worden
			opgevraagd:</p>

		<pre class="code">
<span class="jsp">&lt;%</span>
Lid lid = request.getAttribute(&quot;lid&quot;);
<span class="jsp">%&gt;</span>   
</pre>


		<p>Een servlet heeft een url nodig. Je kunt de url van een servlet
			&quot;mappen&quot; in het web.xml bestand. Dit bevindt zich in de map
			WEB-INF.</p>
		<pre class="code">
&lt;servlet&gt;
	&lt;servlet-name&gt;Sport&lt;/servlet-name&gt;
	&lt;servlet-class&gt;control.SportServlet&lt;/servlet-class&gt;
&lt;/servlet&gt;
	
&lt;servlet-mapping&gt;
	&lt;servlet-name&gt;Sport&lt;/servlet-name&gt;
	<span class="codeplus">&lt;url-pattern&gt;/sport&lt;/url-pattern&gt;</span>
&lt;/servlet-mapping&gt;		   
</pre>

		<h3>Een simpel voorbeeld</h3>
		<p>We gaan de bekende rekenmachine uit deel 3 en 4 nu maken met
			behulp van een MVC ontwerppatroon. Tot nu toe hebben we met
			scriptlets in onze jsp pagina&#39;s gewerkt, maar eigenlijk is het
			gebruik hiervan sinds de invoering van jsp-2 in 2002 verouderd. In
			dit voorbeeld werken we met een jsp pagina die geen scriptlets bevat.
			Om dit mogelijk te maken gebruiken we een zogenaamde JavaBean en
			&quot;Expression Language&quot; (EL).</p>

		<h4>Uitwerking stap voor stap</h4>
		<p>Maak een project met een package rekenmachine. Maak in de
			package een java klasse Rekenmachine. Uiteindelijk moet de
			rekenmachine twee strings kunnen tonen: de uitkomst van de berekening
			en een eventuele waarschuwing als gebruiker bijvoorbeeld per ongeluk
			een letter in plaats van een cijfer invoert.</p>
		<h4>JavaBean (model)</h4>
		<p>Als je van een klasse een JavaBean maakt, kun je straks in je
			jsp pagina attributen van de klasse aanroepen met een speciale tag.
			Om als bean te fungeren moet de klasse aan de volgende voorwaarden
			voldoen:</p>
		<ul>
			<li>er moet een constructor zijn zonder parameters</li>
			<li>de attributen mogen niet public zijn. In onderstaande
				uitwerking zijn de attributen private gedeclareerd</li>
			<li>de attributen die straks in de jsp pagina worden gebruikt
				moeten get en set methoden (getters en setters) hebben</li>
			<li>niet strikt noodzakelijk, maar wel gebruikelijk is om de
				Interface &quot;Serializable&quot; te implementeren in een JavaBean</li>
		</ul>
		<pre class="code">
import java.io.Serializable;

@SuppressWarnings(&quot;serial&quot;)
public class Rekenmachine <span class="codeplus">implements Serializable</span> {
    <span class="codeplus">private</span> String uitkomst; 
    <span class="codeplus">private</span> String waarschuwing;
	
    <span class="comment">//constructor met parameters</span>
    public Rekenmachine(String getal1, String getal2, String functie) {
        uitkomst = &quot;&quot;;
        waarschuwing = &quot;&quot;;
        bereken(getal1, getal2, functie);
    }
	
    <span class="comment">//parameterloze constructor voor bean</span>
    public Rekenmachine<span class="codeplus">()</span> {
        uitkomst = &quot;&quot;;
        waarschuwing = &quot;&quot;;
    }

    <span class="comment">//hulpmethode</span>
    private void bereken(String getal1, String getal2, String functie) {
		
        try {
            double arg1 = Double.parseDouble(getal1);
            double arg2 = Double.parseDouble(getal2);
			
            switch (functie) {
			
                case &quot;+&quot;: uitkomst +=  (arg1 + arg2);
                break;
			
                case &quot;-&quot;: uitkomst +=  (arg1 - arg2);
                break;
			
                case &quot;x&quot;: uitkomst +=  (arg1 * arg2);
                break;
			
                case &quot;/&quot;: uitkomst +=  (arg1 / arg2);
                break;
            }
        } catch(NumberFormatException e) {
            waarschuwing = &quot;Voer twee (decimale) getallen in&quot;;
        }
    }
	
    <span class="comment">//benodigde getters en setters</span>
    public String getUitkomst() {
        return uitkomst;
    }

    public void setUitkomst(String uitkomst) {
        this.uitkomst = uitkomst;
    }

    public String getWaarschuwing() {
        return waarschuwing;
    }

    public void setWaarschuwing(String waarschuwing) {
        this.waarschuwing = waarschuwing;
    }

}
</pre>
		<h4>Servlet (control)</h4>
		<p>Maak in dezelfde package een Servlet. De servlet controleert of
			de gebruiker iets heeft ingevoerd en maakt - afhankelijk van de
			invoer - een object van het type Rekenmachine aan en geeft die als
			attribuut mee aan het request, dat vervolgens naar de jsp pagina
			wordt geforward.</p>

		<pre class="code">
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class RekenmachineServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        <span class="codeplus">Rekenmachine rm = null</span>;
        
        <span class="comment">//maak object rekenmachine afhankelijk van wel of niet invoer gebruiker</span>
        
        <span class="comment">//gebruiker heeft iets ingevoerd</span>
        if (req.getParameter(&quot;reken_functie&quot;) != null) {
            String getal1 = req.getParameter(&quot;reken_arg1&quot;);
            String getal2 = req.getParameter(&quot;reken_arg2&quot;);
            String functie = req.getParameter(&quot;reken_functie&quot;);
            <span class="codeplus">rm = new Rekenmachine(getal1, getal2, functie)</span>;
            
        <span class="comment">//gebruiker heeft nog niets ingevoerd</span>
        } else {
            <span class="codeplus">rm = new Rekenmachine()</span>;
        }
        req.setAttribute(&quot;rekenmachine&quot;, rm);
        RequestDispatcher disp = getServletContext()
                    .getRequestDispatcher(&quot;/rekenmachine.jsp&quot;);
        try {
            disp.forward(req, resp);
        } catch (ServletException e) {
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}    
</pre>

		<p>Als je de servlet hebt gemaakt, kun je er een url aan toekennen
			in je web.xml bestand.</p>

		<pre class="code">
&lt;servlet&gt;
    &lt;servlet-name&gt;Rekenmachine&lt;/servlet-name&gt;
    &lt;servlet-class&gt;rekenmachine.RekenmachineServlet&lt;/servlet-class&gt;
&lt;/servlet&gt;
 &lt;servlet-mapping&gt;
    &lt;servlet-name&gt;Rekenmachine&lt;/servlet-name&gt;
    &lt;url-pattern&gt;<span class="codeplus">/rekenmachine</span>&lt;/url-pattern&gt;
&lt;/servlet-mapping&gt;
&lt;servlet&gt;
</pre>

		<h4>jsp (view)</h4>
		<p>In je jsp pagina kun je het attribuut rekenmachine en haar
			attributen &quot;uitkomst&quot; en &quot;foutboodschap&quot; nu
			meteen aanroepen met &quot;Expression Language&quot; (EL). Je hoeft
			hiervoor geen object te maken en ook is het niet nodig om de klasse
			rekenmachine te importeren.</p>

		<pre class="code">
&lt;form action=&quot;<span class="codeplus">/rekenmachine</span>&quot; method=&quot;get&quot;&gt;
    &lt;table id=&quot;rekenmachine&quot;&gt;
        &lt;tr&gt;
            &lt;td colspan=&quot;2&quot;&gt;
              &lt;input type=&quot;text&quot; name=&quot;reken_arg1&quot; value=&quot;<span
				class="codeplus"><span class="jsp">&#36;{</span>rekenmachine.uitkomst <span
				class="jsp">}</span></span>&quot;&gt;
            &lt;/td&gt;
            &lt;td colspan=&quot;2&quot;&gt;
              &lt;input type=&quot;text&quot; name=&quot;reken_arg2&quot; value=&quot;&quot;&gt;
            &lt;/td&gt;
        &lt;/tr&gt;
        &lt;tr&gt;
            &lt;td&gt;
                &lt;input type=&quot;submit&quot; name=&quot;reken_functie&quot; value=&quot;+&quot;&gt;
            &lt;/td&gt;
            &lt;td&gt;
                &lt;input type=&quot;submit&quot; name=&quot;reken_functie&quot; value=&quot;-&quot;&gt;
            &lt;/td&gt;
            &lt;td&gt;
                &lt;input type=&quot;submit&quot; name=&quot;reken_functie&quot; value=&quot;x&quot;&gt;
            &lt;/td&gt;
            &lt;td&gt;
                &lt;input type=&quot;submit&quot; name=&quot;reken_functie&quot; value=&quot;/&quot;&gt;
            &lt;/td&gt;
        &lt;/tr&gt;
        &lt;tr&gt;
            &lt;td colspan=&quot;4&quot;&gt;<span class="codeplus"><span
				class="jsp">&#36;{</span>rekenmachine.waarschuwing <span class="jsp">}</span></span>&lt;/td&gt;
        &lt;/tr&gt;
    &lt;/table&gt;
&lt;/form&gt;
</pre>

		<div class="opdrachten" id="kalenderopdracht">
			<h2>Praktijkopdracht</h2>
			<p>Een luxe hotel wil een web-app waarmee een klant per kamer een
				beschikbaarheidskalender kan opvragen en - als de kamer beschikbaar
				is - een reservering maken. Maak bij de uitwerking gebruik van een
				servlet.</p>
			<img src="<c:url value="/images/master.png"/>" class="ninja_img_uitleg">


			<div class="bs-callout bs-callout-info" id="jsp_mvc_kalender_app">

				<div id="kalender_container">
					<!-- wordt gevuld met html van KalenderTabelServlet -->
				</div>



				<h3>Kies een kamer</h3>

				<div class="formulier">
					<div class="formulier_regel">
						<label class="formulier_label">kamer</label> <select
							class="formulier_input" id="kamer_bij_keuzekamer">
							<c:forEach items="${kamers}" var="kamernaam">
								<option value="${kamernaam}">${kamernaam}</option>
							</c:forEach>
						</select>
					</div>
					<div class="formulier_regel">
						<button type="button" id="kiesKamerKnop" class="formulier_input">Kies
							kamer</button>
					</div>


				</div>



				<!-- ******* EINDE KALENDER DIV******* -->

			</div>

		</div>
	</div>
</div>
<%@ include file="/AO/JSP_Java_DB/includes/bottom.html"%>
<style>
	#reservering_datum, #maandkiezer_maand {
		width: 20em;
		text-align: center;
	}
</style>
<script>
	$(document).ready(
			function() {

				$("li#deel-5").addClass("selected");

				$(document).on(
						'click',
						'#vorige',
						function() {

							var sleutel = $("#kamer_verborgen").val();
							var maand = $("#maand_verborgen").val();
							var jaar = $("#jaar_verborgen").val();

							$.get("/kalendertabel?vorige=x&sleutel=" + sleutel
									+ "&maand=" + maand + "&jaar=" + jaar,
									function(responseText) {
										$("#kalender_container").html(
												responseText);
									});
						});

				$(document).on(
						'click',
						'#volgende',
						function() {
							var sleutel = $("#kamer_verborgen").val();
							var maand = $("#maand_verborgen").val();
							var jaar = $("#jaar_verborgen").val();

							$.get("/kalendertabel?volgende=x&sleutel="
									+ sleutel + "&maand=" + maand + "&jaar="
									+ jaar, function(responseText) {
								$('#kalender_container').html(responseText);
							});
						});

				$(document).on(
						'click',
						'#reservering_knop',
						function() {
							var sleutel = $("#kamer_verborgen").val();
							var datum = $("#reservering_datum").val();
							var maand = $("#maand_verborgen").val();
							var jaar = $("#jaar_verborgen").val();
							$.get("/kalendertabel?reservering_knop=x&datum="
									+ datum + "&maand=" + maand + "&jaar="
									+ jaar + "&sleutel=" + sleutel, function(
									responseText) {
								$('#kalender_container').html(responseText);
							});
						});

				$("#kiesKamerKnop").click(
						function() {
							var sleutel = $("#kamer_bij_keuzekamer").val();
							if ($("#maand_verborgen").length) {
								var maand = $("#maand_verborgen").val();
								var jaar = $("#jaar_verborgen").val();
								$.get("/kalendertabel?kiesKamerKnop=x&sleutel="
										+ sleutel + "&maand=" + maand
										+ "&jaar=" + jaar,
										function(responseText) {
											$("#kalender_container").html(
													responseText);
										});
							} else {
								$.get("/kalendertabel?kiesKamerKnop=x&sleutel="
										+ sleutel,
										function(responseText) {
											$("#kalender_container").html(
													responseText);
										});
							}
						});

			});
</script>
</html>