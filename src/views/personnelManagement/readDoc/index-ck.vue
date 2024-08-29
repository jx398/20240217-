<template>
  <div id="app">
    <ckeditor
      v-model="editorData"
      :editor="editor"
      :config="editorConfig"
    ></ckeditor>
  </div>
</template>

<script>
  import Editor from '@ckeditor/ckeditor5-build-classic'

  export default {
    name: 'App',
    data() {
      return {
        editor: Editor,
        editorData: '<p>Content of the editor.</p>',
        editorConfig: {
          // The configuration of the editor.
        },
      }
    },
  }
</script>
