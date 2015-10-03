require 'date'

class SuperSquareMaker
  def initialize(start)
    @start_date = start
    @outline = flatten_outline
    @all_dates = []
  end

  def flatten_outline
     %w(
    -###########--#####------########-----#######--#####
    ------#**-----#--##------#-------##---#*--------####
    ------#*-----##---#------#*------##---#**--------##-
    -----##------#**--##-----#*------###--#####-------#-
    -----##-----#########----#**-----##---#*------------
    -#*-###-----##*----##*---#**----##*---#**--------*##
    -######----##**----###*--#######**----########---###
    ).map { |l| l.split('') }.transpose.flatten
  end

  def shades
    count = 1
    @outline.uniq.sort.each_with_index do |char, i|
      generate_commit_dates(create_mask_for(char), i + count)
      count += 1
    end
  end

  def create_mask_for(char)
    @outline.map{ |c| c == char }
  end

  def fill?(date, mask)
    idx = (date - @start_date).to_i % mask.size
    mask[idx]
  end

  def dates
    @start_date.upto(@start_date + @outline.count)
  end

  def all_dates
    @all_dates
  end

  def commit_on(date, num_commits)
    (0...num_commits).map { |i| date.to_time + i * 60 ** 2 }
  end

  def generate_commit_dates(mask, n)
    @all_dates.concat(dates.inject([]) do |all_dates, date|
      fill?(date, mask) ? all_dates.concat(commit_on(date, n)) : all_dates
    end.map(&:to_s))
  end

  def commit
    @all_dates.each do |date|
      `GIT_AUTHOR_DATE="#{date}" GIT_COMMITTER_DATE="#{date}" gcm "super_square_#{date}"`
    end
  end
end


SuperSquareMaker.new(Date.new(2014, 9, 28))
