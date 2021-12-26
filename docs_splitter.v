import os

const dir_name = "v_docs" // TODO: remove it and get dir name from cli

struct Content {
mut:
	title string
	description string
}

fn main() {
	docs_file := $embed_file("docs.md") // TODO: replace it to the V document url
	contents_str := split_contents_str(docs_file.to_string())

	mut content_obj := Content{}
	for content_str in contents_str {
		content_obj = content_str_to_obj(content_str)
		create_docs_file(content_obj) ?
	}
}

fn (mut c Content) fill_descriptions(description string) {
	c.description = "# ${c.title}\n"
	c.description += description
}

fn split_contents_str(docs_str string) []string {
	splitter := "\n## " // ##: markdown symbol meaning subtitle
	return docs_str.split(splitter)
}

fn content_str_to_obj(content string) Content {
	mut title := ""
	mut content_obj := Content{}
	for i in 0 .. content.len {
		if content[i].ascii_str() == "\n" {
			content_obj.title = title
			content_obj.fill_descriptions(content[i + 1 ..])
			break
		}
		title += content[i].ascii_str()
	}

	return content_obj
}

fn create_docs_file(content_obj Content) ? {
	os.write_file("${dir_name}/${content_obj.title}.md", content_obj.description) ?
}
