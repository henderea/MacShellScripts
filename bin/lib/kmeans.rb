$LOAD_PATH << File.dirname(__FILE__)

require 'maputil'

def f_test(clusters, means, cnt, avg)
  ev = 0
  (0...means.count).each { |i|
    unless clusters[i].empty?
      ni = clusters[i].count
      ev += ni * ((means[i] - avg) ** 2)
    end
  }
  ev /= means.count - 1
  uv = 0
  (0...means.count).each { |i|
    unless clusters[i].empty?
      (0...clusters[i].count).each { |j|
        uv += (clusters[i][j] - means[i]) * (clusters[i][j] - means[i])
      }
    end
  }
  uv /= (cnt - means.count)
  (ev / uv)
end

def f_test2(clusters, means, cnt)
  uv = 0
  (0...means.count).each { |i|
    unless clusters[i].empty?
      tmp = 0
      (0...clusters[i].count).each { |j|
        tmp += (clusters[i][j] - means[i]) ** 2
      }
      tmp /= clusters[i].count
      uv  += Math.sqrt(tmp)
    end
  }
  (uv / (cnt - means.count))
end

module Enumerable
  def nmeans(max_k = 10, threshold = 0.05)
    su  = sum
    cnt = count
    avg = su / cnt
    kso = kmeans(1)
    cso = get_clusters(kso)
    fto = f_test2(cso, kso, cnt)
    ks  = kmeans(2)
    cs  = get_clusters(ks)
    ft  = f_test(cs, ks, cnt, avg)
    ft2 = f_test2(cs, ks, cnt)
    if ft2 >= fto
      return kso
    end
    (3..max_k).each { |k|
      kso = ks
      fto = ft
      ks  = kmeans(k)
      cs  = get_clusters(ks)
      ft  = f_test(cs, ks, cnt, avg)
      if ((ft - fto) / fto) < threshold
        return kso
      end
    }
    ks
  end

  def kmeans(k)
    mi   = min
    ma   = max
    diff = ma - mi
    ks   = []
    (1..k).each { |i|
      ks[i - 1] = mi + (i * (diff / (k + 1)))
    }
    kso = false
    while ks != kso
      kso      = ks
      clusters = get_clusters(kso)
      ks = []
      clusters.each_with_index { |val, key|
        cnt = val.count
        if cnt <= 0
          ks[key] = kso[key]
        else
          sum = val.sum
          ks[key] = (sum / cnt)
        end
      }
      ks.sort
    end
    ks
  end

  def get_clusters(means)
    clusters = []
    (0...means.count).each { |i|
      clusters[i] = []
    }
    each { |item|
      cluster  = false
      distance = false
      (0...means.count).each { |i|
        diff = (means[i] - item).abs
        if distance == false || diff < distance
          cluster  = i
          distance = diff
        end
      }
      clusters[cluster][clusters[cluster].count] = item
    }
    clusters
  end
end