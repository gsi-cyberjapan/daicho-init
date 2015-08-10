require 'sequel'
require '../server-load/server-load.rb'
$server = Server.new

def _commit(db, updates)
  begin
    db.transaction do
      updates.each {|r|
        db[:cache].insert(r)
      }
    end
  rescue
    print $!, " -- retrying...\n"
    sleep rand
    retry
  end
  if $server.loadavg > 20
    print "sleep because busy.\n"
    sleep 10 * rand
  else
    print "."
  end
end

def init_daicho(mokuroku_in, daicho_path, ext)
  db = Sequel.sqlite(daicho_path)
  unless db.tables.include?(:cache)
    db.create_table :cache do
      primary_key String :zxy
      index :zxy, :unique => true
      String :md5
      Integer :mtime
      Integer :size
      Integer :z
      index :z
      Integer :x
      index :x
      Integer :y
      index :y
    end
  end
  updates = []
  mokuroku_in.each {|l|
    (path, mtime, size, md5) = l.strip.split(',')
    mtime = mtime.to_s
    size = size.to_s
    zxy = path.split('.')[0]
    (z, x, y) = zxy.split('/').map{|v| v.to_i}
    updates << {
      :zxy => zxy, :md5 => md5, :mtime => mtime, :size => size,
      :z => z, :x => x, :y => y
    }
    if updates.size == 1000
      _commit(db, updates)
      updates = []
    end
  }
  _commit(db, updates)
end
