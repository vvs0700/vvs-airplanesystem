var auta

function CloseShop() {
    $("#shopmenu").hide();
    $(".wrapper").html('');
    $.post('http://vanity_autosalon/CloseMenu', JSON.stringify({}));
}


$(document).keyup(function(e) {
     if (e.key === "Escape") {
        CloseShop()
    }
});

function PostaviSideBar(page, max){
    $('.wrapper').html('');
    $('.wrapper').append(`
        <div class="picture" style="background-image: url(`+ auta.cars[page].imglink +`)"></div>
    `);
    if (page == 1) {
        $('#item1').html('');
        $('#item2').html('');
        $('#item3').html(`<p></p> <span>--- Nema vise auta ---</span>`);
    }else if (page == 2) {
        $('#item1').html('');
        $('#item2').html(`<p></p> <span>--- Nema vise auta ---</span>`);
        $('#item3').html(`<p></p> <span>`+ auta.cars[page-1].name +`</span>`);
    }else if (page == 3) {
        $('#item1').html(`<p></p> <span>--- Nema vise auta ---</span>`);
        $('#item2').html(`<p></p> <span>`+ auta.cars[page-2].name +`</span>`);
        $('#item3').html(`<p></p> <span>`+ auta.cars[page-1].name +`</span>`);
    }else {
        $('#item1').html(`<p></p> <span>`+ auta.cars[page-3].name +`</span>`);
        $('#item2').html(`<p></p> <span>`+ auta.cars[page-2].name +`</span>`);
        $('#item3').html(`<p></p> <span>`+ auta.cars[page-1].name +`</span>`);
    }

    if (page == max) {
        $('#item7').html('');
        $('#item6').html('');
        $('#item5').html(`<p></p> <span>--- Nema vise auta ---</span>`);
    } else if (page == (max-1)) {
        $('#item7').html('');
        $('#item6').html(`<p></p> <span>--- Nema vise auta ---</span>`);
        $('#item5').html(`<p></p> <span>`+ auta.cars[page+1].name +`</span>`);
    } else if (page == (max-2)) {
        $('#item7').html(`<p></p> <span>--- Nema vise auta ---</span>`);
        $('#item6').html(`<p></p> <span>`+ auta.cars[page+2].name +`</span>`);
        $('#item5').html(`<p></p> <span>`+ auta.cars[page+1].name +`</span>`);
    } else {
        $('#item7').html(`<p></p> <span>`+ auta.cars[page+3].name +`</span>`);
        $('#item6').html(`<p></p> <span>`+ auta.cars[page+2].name +`</span>`);
        $('#item5').html(`<p></p> <span>`+ auta.cars[page+1].name +`</span>`);
    }
}

$(document).ready(function(){
    var page = 1;
    var mpage = 0;

    $(".card-body").on('click', ':button', function () {
        $("#shopmenu").fadeOut();
        $.post('http://vanity_autosalon/BuyVehicle', JSON.stringify({id: $(this).data('id')}));
    });

    $("body").on("keyup", function (key) {
        closeKeys = [40]
        upKey = [38]

        if (closeKeys.includes(key.which)) {
            $("#stranica-"+page).hide();
            if (page < mpage) {
                page = page + 1;
            }
            $("#stranica-"+page).show();
            $("#mpage").html(page + "/" + mpage)
            PostaviSideBar(page, mpage)
            $('#item4').html(`<p></p> <span>`+ auta.cars[page].name +`</span>`);
            $('#ime-auta').html(auta.cars[page].name);
            $('#cena-auta').html('Cena ' + auta.cars[page].price + "€");

        }
        if (upKey.includes(key.which)) {
            $("#stranica-"+page).hide();
            if (page > 1) {
                page = page - 1;
            }
            $("#stranica-"+page).show();
            $("#mpage").html(page + "/" + mpage)
            PostaviSideBar(page, mpage)
            $('#item4').html(`<p></p> <span>`+ auta.cars[page].name +`</span>`);
            $('#ime-auta').html(auta.cars[page].name);
            $('#cena-auta').html('Cena ' + auta.cars[page].price + "€");
        }
    });
    $(".purchase").click( function() {
        CloseShop()
        $.post('http://vanity_autosalon/BuyVehicle', JSON.stringify({ id: auta.cars[page]}));
    });
    $(".test").click( function() {
        CloseShop()
        $.post('http://vanity_autosalon/Test', JSON.stringify({ id: auta.cars[page]}));
    });
    window.addEventListener('message', function(event) {
        var data = event.data;
        auta = event.data;
        if (data.show) {
            let apage = 1;
            $("#shopmenu").fadeIn();
            mpage = data.cars.length / 2;
            $("#mpage").html(page + "/" + mpage)
            PostaviSideBar(page, mpage)
            $('#item4').html(`<p></p> <span>`+ data.cars[page].name +`</span>`);
            $('#ime-auta').html(data.cars[page].name);
            $('#cena-auta').html('Cena ' + data.cars[page].price + "€");
        }    
    });
});
