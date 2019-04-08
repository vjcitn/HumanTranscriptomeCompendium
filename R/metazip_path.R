metazip_path = function() {
 ds = get_ds4841()
 get("zipf", envir=environment(ds@doc_retriever))
}

