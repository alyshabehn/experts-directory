require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'set'

class MembersController < ApplicationController
  def index
    @members = Member.all
  end

  def show
    @member = Member.find(params[:id])

    if params[:search]
      headings = Heading.search(
          params[:search],
          @member.friends.map{ |f| f.id})
      @path_dict = headings
                       .map {|h| [h, find_introduction_path(@member, h.member)]}
                       .to_h
    else
      @path_dict = {}
    end
  end

  def create
    @member = Member.new(params.require(:member).permit(:name, :website))

    page = Nokogiri::HTML(open(@member.website))

    headers = page.css("h1").map{ |x| x.text}
                  .concat(page.css("h2").map{ |x| x.text})
                  .concat(page.css("h3").map{ |x| x.text})

    @member.save
    headers.each do |h|
      @member.headings.create(heading: h)
    end

    redirect_to @member
  end

private

  # I opted for breadth first search here, since I assume a user
  # would want to use the shortest path to introduction possible.
  def find_introduction_path(member, non_friend)
    friend_queue = Array.new #to be used as a queue
    visited_nodes = Set.new
    meta = Hash.new

    meta[member] = nil
    friend_queue.unshift(member)

    while !friend_queue.empty? do

      subtree_root = friend_queue.pop

      if subtree_root == non_friend
          return construct_path(subtree_root, meta)
      end

      subtree_root.friends.each { |friend|


        if visited_nodes.include?(friend)
          next
        end

        if !friend_queue.include?(friend)
            meta[friend] = subtree_root
            friend_queue.unshift(friend)
        end
      }
      visited_nodes.add(subtree_root)

    end

  end

  def construct_path(state, meta)
    currentNode = state
    introduction_path = [currentNode]

    while meta[currentNode] != nil do
      step = meta[currentNode]
      introduction_path.push(step)
      currentNode = step
    end

    introduction_path.reverse!

    return introduction_path.map{|member| member.name }.join(" -> ")

  end

end
