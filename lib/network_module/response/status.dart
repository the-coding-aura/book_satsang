/// Lifecycle states for an [ApiResponse].
///
/// Progresses from [idle] through [loading] to either [completed] or [error].
enum Status { idle, loading, completed, error }
