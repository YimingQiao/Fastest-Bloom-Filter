use std::thread;

pub(crate) fn workers(items: usize, requested: usize, limit: usize) -> usize {
    if items < (1 << 14) {
        return 1;
    }
    let requested = if requested == 0 {
        thread::available_parallelism().map_or(1, usize::from)
    } else {
        requested
    };
    requested.min(limit).min(items / 4096).clamp(1, 1024)
}
