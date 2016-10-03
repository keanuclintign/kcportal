<%@ include file="/WEB-INF/jsp/init.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/ny-you.css">
<script src="<%=request.getContextPath()%>/js/vendor/modernizr-2.6.2.min.js"></script>


<input type="hidden" value="" id='dataFilterCategory'>

<section id="about">
    <div class="wrapper-page">

        <article id="wrapper-about">

            <p class="subheading">[INSERT DATA FILTER CATEGORY HERE]</p>
            <!-- <button id="btn-toggleCategory">ToggleAdvanced</button> -->
            <div id="wrapper-dataFilterCategorySelection">
                <p>You Picked..</p>
                <div id="dataFilterCategorySelection">&nbsp;</div>
            </div>

            <ul class="less" id="data-filter-category">
                <!-- [DATA FILTER GROUP 1]-->
                <li data-hue="fee799">&nbsp;</li>
                <li data-hue="fdd978">&nbsp;</li>
                <li data-hue="fdcb5a">&nbsp;</li>
                <li data-hue="fcc143">&nbsp;</li>
                <li data-hue="f7b324">&nbsp;</li>
                <li data-hue="f5a800">&nbsp;</li>
                <li data-hue="ee9c00">&nbsp;</li>
                <li data-hue="e69100">&nbsp;</li>
                <li data-hue="e28800">&nbsp;</li>
                <li class="separator" data-hue="da7c00">
                    <span class="dataFilterHue-name">[DATA FILTER GROUP 1]</span>
                </li>

                <!-- [DATA FILTER GROUP 2]-->
                <li data-hue="d37400">&nbsp;</li>
                <li data-hue="cb6c00">&nbsp;</li>
                <li data-hue="c66400">&nbsp;</li>
                <li data-hue="bf5c01">&nbsp;</li>
                <li data-hue="b65300">&nbsp;</li>
                <li data-hue="b04f00">&nbsp;</li>
                <li data-hue="ac4700">&nbsp;</li>
                <li data-hue="a24000">&nbsp;</li>
                <li data-hue="9c3900">&nbsp;</li>
                <li class="separator" data-hue="963500">
                    <span class="dataFilterHue-name">[DATA FILTER GROUP 2]</span>
                </li>

                <!-- [DATA FILTER GROUP 3]-->
                <li data-hue="912f00">&nbsp;</li>
                <li data-hue="8b2c00">&nbsp;</li>
                <li data-hue="832500">&nbsp;</li>
                <li data-hue="7e1f00">&nbsp;</li>
                <li data-hue="771c01">&nbsp;</li>
                <li data-hue="721b00">&nbsp;</li>
                <li data-hue="6c1600">&nbsp;</li>
                <li data-hue="671000">&nbsp;</li>
                <li data-hue="620f00">&nbsp;</li>
                <li class="separator" data-hue="5b0d00">&nbsp;</li>

                <!-- [DATA FILTER GROUP 3]-->
                <li data-hue="560c03">&nbsp;</li>
                <li data-hue="5d0a02">&nbsp;</li>
                <li data-hue="500a08">&nbsp;</li>
                <li data-hue="4a0605">&nbsp;</li>
                <li data-hue="440706">&nbsp;</li>
                <li data-hue="420807">&nbsp;</li>
                <li data-hue="3c0908">&nbsp;</li>
                <li data-hue="390708">&nbsp;</li>
                <li data-hue="39080b">&nbsp;</li>
                <li class="separator" data-hue="35090a">
                    <span class="dataFilterHue-name">[DATA FILTER GROUP 3]</span>
                </li>
            </ul>

        </article>
    </div>
</section>

<section id="dataFile">
    <div class="wrapper-page">
        <article>
            <h2>[INSERT DATA FILE SELECTOR HERE]</h2>
            <ul id="list-dataFile">
                <li data-dataFile="data-file-1" class="active">[DATA FILE 1]</li>
                <li data-dataFile="data-file-2">[DATA FILE 2]</li>
                <li data-dataFile="data-file-3">[DATA FILE 3]</li>
                <li data-dataFile="data-file-4">[DATA FILE 4]</li>
            </ul>
        </article>
    </div>
</section>

<section class="context-viz active" id="category">

    <aside id="wrapper-category">
        <div id="styleHead">
            <h3>[INSERT DATA FILTER GROUP]</h3>
        </div>
        <ul id="list-dataFilter">
        </ul>
    </aside>

    <div class="wrapper-page">
        <article>
            <div id="wrapper-viz">
            </div>
        </article>
    </div>

    <aside id="wrapper-details">
        <ul id="list-usersummary">
            <li id="usersummary-name"></li>

            <li id="info">
            </li>

        </ul>
    </aside>

</section>

<script src="<%=request.getContextPath()%>/js/vendor/jquery.hotkeys.js"></script>

<script src="<%=request.getContextPath()%>/js/vendor/d3.js"></script>
<script src="<%=request.getContextPath()%>/js/vendor/packages.js"></script>

<script src="<%=request.getContextPath()%>/js/vendor/main.js"></script>