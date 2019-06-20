<%--
  Created by IntelliJ IDEA.
  User: piet
  Date: 19-02-18
  Time: 13:24
  To change this template use File | Settings | File Templates.
--%>

<%
    if (request.getAttribute("fromserver") == null) {
        response.sendRedirect("/AO/planningoverview");

    } else {
%>

<%@ include file="/includes/pagetop-all.jsp" %>
<div class="container">
    <%@ include file="/AO/daily_standups/includes/zijmenu.jsp" %>
    <div class="col-md-8">
        <form role="form" id="planning_overview_form">
            <div class="form-group">
                <label for="cohort_kiezer">Cohort:</label>
                <select class="form-control" id="cohort_kiezer" name="cohort_kiezer">
                    <option value="kies">Kiezen...</option>
                    <option value="2015">2015</option>
                    <option value="2016">2016</option>
                    <option value="2017">2017</option>
                    <option value="2018">2018</option>
                </select>
            </div>
        </form>

        <div class="table-responsive hidden" id="plannings_tabel_wrapper">
            <table id="plannings_tabel" class="table table-bordered table-condensed table-striped">
                <thead>
                <tr>
                    <th>Naam/tijd</th>
                    <th>Planning</th>
                    <th>Hulp nodig</th>
                </tr>
                </thead>
                <tbody id="tbody">

                </tbody>



            </table>
        </div>

        <div class="loading_img_container hidden" id="loading_cohort">
            <img src="<c:url value="/images/ajax-loader.gif"/>">
        </div>

    </div>


</div>

<%@ include file="/AO/daily_standups/includes/bottom.html" %>

<script type="text/javascript">
    $(document).ready(
        function () {
            const cohortKiezer = $('#cohort_kiezer');
            const imgContainer = $('#loading_cohort');
            const tabelWrapper = $('#plannings_tabel_wrapper');
            const planningsTabel = $('#plannings_tabel');
            const tablebody = $('#tbody');
            cohortKiezer.on('change', function () {
                imgContainer.removeClass('hidden');
                if (!tabelWrapper.hasClass('hidden')) {
                    tabelWrapper.addClass('hidden');
                }
                tablebody.html("");
                let cohort = cohortKiezer.val();
                let cursor = 'init';
                if (cohort !== "kies") {
                    getTableRows(cohort, cursor);
                }
            });

            function getTableRows(cohort, cursor) {
                const url = "/AO/planning/admin/planningoverzicht";
                $.ajax({
                    type: "POST",
                    url: url,
                    data: {
                        cohort: cohort,
                        cursor: cursor
                    },
                    success: function (data) {
                        const json = $.parseJSON(data);
                        const tableRows = json['rows'];
                        const cursor = json['cursor'];
                        if (tabelWrapper.hasClass('hidden')) {
                            tabelWrapper.removeClass('hidden');
                        }
                        $('#tbody').append(tableRows);
                        // planningsTabel.find('tbody').append(tableRows);

                        cohortKiezer.val("kies");
                        if (cursor !== "null") {
                            getTableRows(cohort, cursor);
                        } else {
                            if (!imgContainer.hasClass('hidden')) {
                                imgContainer.addClass('hidden');
                            }
                        }
                    }
                });
            }
            $(document).on("click", ".klik_user", function () {
                let email = $(this).data("email");
                window.open("/AO/planning/studentplanningen?email=" + email);
            });

            // approve project ticket
            $(document).on("click", ".approve-ticket", function () {
                let $button = $(this);
                $button.text('....');
                $button.attr("disabled", true);
                const ticketId = $button.data("ticketid");
                const url = "/AO/planning/admin/planningoverzicht";
                $.ajax({
                    type: "POST",
                    url: url,
                    data: {
                        ticketId: ticketId
                    },
                    success: function (data) {
                        if (data !== "not good") {
                            $button.text('approved');
                        } else {
                            alert("Er is iets mis gegaan. Ververs pagina en probeer opnieuw");
                        }
                    }
                });
            });
            $('#overzicht_planningen').addClass('selected');
        });


</script>
<%
    }
%>

