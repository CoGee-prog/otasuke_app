// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import ('jquery')

Rails.start()
// Turbolinks.start()
ActiveStorage.start()

// タブ
$(function(){
    $(".tab").on("click",function(){
        let this_class = $(this).attr("class");
        let class_Array = this_class.split(" ");
        $("#lamp").removeClass().addClass(`${class_Array[1]}`);
    });
});


// 画像プレビュー
$(function(){
    $('#team_image').on('change', function (e) {
        let reader = new FileReader();
        reader.onload = function (e) {
            $("#preview").attr('src', e.target.result);
        }
        reader.readAsDataURL(e.target.files[0]);
    });
});
    