// Prevent uploading of big images.
document.addEventListener("turbo:load", function() {
  document.addEventListener("change", function(event) {
    let image_upload = document.querySelector('#micropost_image');

    if (!image_upload || !image_upload.files.length) return;

    const size_in_megabytes = image_upload.files[0].size / 1024 / 1024;

    if (size_in_megabytes > Settings.default.image.SIZE_LIMIT) {
      alert(I18n.t("microposts.image.too_big"));
      image_upload.value = "";
    }
  });
});
