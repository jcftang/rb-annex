require 'digest'
require 'uuid'

module Annex
  class Key
    include ActiveModel::Validations
    attr_accessor :size, :hash, :mtime, :hash_alg, :annex_key, :annex_hash, :annex_hash_1, :annex_hash_2

    def gen_key hash_alg, filename
      self.hash_alg = hash_alg
      self.hash = checksum(hash_alg, filename)
      self.size = File.size(filename)

      unless self.mtime.nil?
        self.annex_key = "#{hash_alg.upcase}-s#{size}-m#{mtime}--#{hash}"
      else
        self.annex_key = "#{hash_alg.upcase}-s#{size}--#{hash}"
      end

      return annex_key
    end

    def get_annex_hash(annex_key)
      self.annex_hash = Digest::MD5.hexdigest(annex_key)
      annex_hash_array = annex_hash.scan(/.{1,3}/)
      self.annex_hash_1 = annex_hash_array[0]
      self.annex_hash_2 = annex_hash_array[1]
    end

    def checksum hash_alg, filename
      case hash_alg
      when "worm"
        worm(filename)
      when "sha256"
        sha256(filename)
      else
        sha256(filename)
      end
    end

    def sha256(filename)
      Digest::SHA256.file(filename).hexdigest
    end

    def worm(filename)
      t = Time.new
      self.mtime = t.to_i

      uuid = UUID.new
      uuid.generate
    end

  end
end
