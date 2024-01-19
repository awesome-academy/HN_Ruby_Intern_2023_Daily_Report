class BookCommentSerializer < ApplicationSerializer
  attributes :id, :star_rate, :content

  def content
    object.content.body.to_plain_text
  end
end
