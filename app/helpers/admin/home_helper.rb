module Admin::HomeHelper
  def populate_key_by raw, *attributes, &block
    collection = block.call.where(id: raw.keys)
                      .index_by(&:id)
                      .values_at(*raw.keys)
    collection = collection.pluck(*attributes) unless attributes.empty?
    collection.zip raw.values
  end

  def format_period_key raw, type
    keys = raw.keys
    case type
    when :week
      keys = keys.map{|week| "#{t('datetime.week')} #{week}"}
    when :quarter
      keys = keys.map do |year, quarter|
        "#{t('datetime.quarter')} #{quarter}/#{year}"
      end
    end
    keys.zip raw.values
  end

  def trending_book period: :month, limit: Settings.n_trending_items
    BorrowItem.group(:book_id)
              .recently(period)
              .order("count_id desc")
              .limit(limit)
              .count(:id)
  end

  def trending_book_all_time
    week = trending_book(period: :week)
    week = week.transform_values do |v|
      {week: v} if v > 1
    end
    month = trending_book(period: :month)
    month = month.transform_values do |v|
      {month: v} if v > 1
    end
    year = trending_book(period: :year)
    year = year.transform_values do |v|
      {year: v} if v > 1
    end
    raw = week.deep_merge(month).deep_merge(year).compact
    populate_key_by(raw){Book.with_attached_image}
  end

  def stat_book_genre limit = Settings.n_pie_items
    raw = BookGenre.group(:genre_id)
                   .order("count_id desc")
                   .limit(limit)
                   .count(:id)
    populate_key_by(raw, :name){Genre}
  end

  def stat_book_author limit = Settings.n_pie_items
    raw = BookAuthor.group(:author_id)
                    .order("count_id desc")
                    .limit(limit)
                    .count(:id)
    populate_key_by(raw, :name){Author}
  end

  def stat_book_publisher limit = Settings.n_pie_items
    raw = Book.group(:publisher_id)
              .order("count_id desc")
              .limit(limit)
              .count(:id)
    populate_key_by(raw, :name){Publisher}
  end

  def group_by_period collection, period: :month
    group_by_map = {
      week: :date,
      month: :date,
      year: :week,
      all: :quarter
    }
    group = group_by_map[period]
    raw = collection.recently period
    raw = raw.period_group :year if period == :all
    raw = raw.period_group group
    raw = raw.count
    format_period_key raw, group
  end

  def stat_borrow_date period: :month
    group_by_period BorrowInfo, period:
  end

  def stat_borrow_genre limit = Settings.n_pie_items, period: :month
    join_clause = "book_genres ON borrow_items.book_id = book_genres.book_id"
    raw = BorrowItem.recently(period)
                    .joins("INNER JOIN #{join_clause}")
                    .group(:genre_id)
                    .order("count_borrow_items_id DESC")
                    .limit(limit)
                    .count("borrow_items.id")
    populate_key_by(raw, :name){Genre}
  end
end
